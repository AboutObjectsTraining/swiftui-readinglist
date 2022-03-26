// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

final class ReadingListViewModel: ObservableObject {
    let store: DataStore
    @Published var isAddingBook = false
    @Published var isEditingTitle = false
    @Published var readingList: ReadingList
    @Published var books: [Book] = [] {
        didSet { makeCellViewModels() }
    }
    
    private var cellViewModels: [BookCellViewModel] = []
        
    init(store: DataStore = DataStore()) {
        self.store = store
        self.readingList = ReadingList(title: "Empty", books: [])
    }
}

// MARK: BookCell view models
extension ReadingListViewModel {
    
    private func makeCellViewModels() {
        cellViewModels = books.map {
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
        self.books = readingList.books
    }
    
    func addBook(_ book: Book) {
        books.append(book)
        cellViewModels.append(BookCellViewModel(book: book, updateBook: update(book:)))
        save()
    }
    
    func update(book: Book) {
        guard let index = books.firstIndex(where: { $0.id == book.id }) else {
            print("Unable to find book \(book)")
            return
        }
        books[index] = book
        save()
    }
    
    func deleteBooks(at indexSet: IndexSet) {
        books.remove(atOffsets: indexSet)
        cellViewModels.remove(atOffsets: indexSet)
        save()
    }
    
    func moveBooks(fromOffsets: IndexSet, toOffset: Int) {
        books.move(fromOffsets: fromOffsets, toOffset: toOffset)
        cellViewModels.move(fromOffsets: fromOffsets, toOffset: toOffset)
        save()
    }
    
    func save() {
        readingList.books = books
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
