// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

final class ReadingListViewModel: ObservableObject {
    let store: DataStore
    @Published var isAddingBook = false
    @Published var readingList: ReadingList
    @Published var books: [Book] = []
        
    init(store: DataStore = DataStore()) {
        self.store = store
        
        // TODO: fetch and save in background
        self.readingList = store.fetch()
        self.books = readingList.books
    }
}

// MARK: Actions
extension ReadingListViewModel {
    
    func addBook(_ book: Book) {
        books.append(book)
        save()
    }
    
    func deleteBooks(at indexSet: IndexSet) {
        books.remove(atOffsets: indexSet)
        save()
    }
    
    func moveBooks(fromOffsets: IndexSet, toOffset: Int) {
        books.move(fromOffsets: fromOffsets, toOffset: toOffset)
        save()
    }
    
    private func save() {
        readingList.books = books
        
        do {
            try store.save(readingList: readingList)
        } catch {
            print("Couldn't save reading list to store \(store)")
        }
    }
}


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
