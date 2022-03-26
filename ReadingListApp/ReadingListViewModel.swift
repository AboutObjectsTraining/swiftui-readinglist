// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

final class ReadingListViewModel: ObservableObject {
    let store: DataStore
    @Published var isAddingBook = false
    @Published var isEditingTitle = false
    @Published var readingList: ReadingList {
        didSet { makeCellViewModels()  }
    }
    @Published var cellViewModels: [BookCellViewModel] = []
        
    init(store: DataStore = DataStore()) {
        self.store = store
        readingList = ReadingList(title: "Empty", books: [])
    }
}

// MARK: BookCell view models
extension ReadingListViewModel {
    
    private func makeCellViewModels() {
        cellViewModels = readingList.books.map {
            BookCellViewModel(book: $0, updateBook: update(book:))
        }
    }

    func cellViewModel(for book: Book) -> BookCellViewModel {
        let cellVM = cellViewModels.first(where: { $0.book.id == book.id })
        guard let cellVM = cellVM else {
            fatalError("Unable to find cell view model for book: \(book)")
        }
        return cellVM
    }
}

// MARK: Actions
extension ReadingListViewModel {
    
    func loadIfEmpty() {
        guard readingList.books.isEmpty else { return }
        
        do {
            readingList = try store.fetch()
        } catch {
            print("Unable to fetch ReadingList from store \(store)")
        }
    }
    
    func addBook(_ book: Book) {
        let newCellVM = BookCellViewModel(book: book, updateBook: update(book:))
        cellViewModels.append(newCellVM)
        save()
    }
    
    func update(book: Book) {
        guard let cellVM = cellViewModels.first(where: { $0.book.id == book.id }) else {
            fatalError("\(#function) - Unable to find book \(book)")
        }
        cellVM.book = book
        save()
    }
    
    func deleteBooks(at indexSet: IndexSet) {
        cellViewModels.remove(atOffsets: indexSet)
        save()
    }
    
    func moveBooks(fromOffsets: IndexSet, toOffset: Int) {
        cellViewModels.move(fromOffsets: fromOffsets, toOffset: toOffset)
        save()
    }
    
    func save() {
        readingList.books = cellViewModels.map { $0.book }
        
        do {
            try store.save(readingList: readingList)
        } catch {
            print("Couldn't save reading list to store \(store)")
        }
    }
}

#if DEBUG
extension ReadingListViewModel {
    static let empty = ReadingListViewModel()
    static var loaded: ReadingListViewModel = {
        let loaded = ReadingListViewModel()
        loaded.loadIfEmpty()
        return loaded
    }()
}
#endif

//final class AddBookViewModel: ObservableObject {
//    var readingListVM: ReadingListViewModel
//    var isAddingBook: Bool {
//        get { readingListVM.isAddingBook }
//        set { readingListVM.isAddingBook = newValue }
//    }
//
//    func addBook(_ book: Book) {
//        readingListVM.addBook(book)
//    }
//
//    init(readingListViewModel: ReadingListViewModel) {
//        self.readingListVM = readingListViewModel
//    }
//}
