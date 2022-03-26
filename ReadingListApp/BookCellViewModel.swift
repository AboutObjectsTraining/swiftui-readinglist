// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

final class BookCellViewModel: ObservableObject {
    
    private var updateBook: (_ book: Book) -> Void
    
    @Published var book: Book
    
    init(book: Book, updateBook: @escaping (_ book: Book) -> Void) {
        self.book = book
        self.updateBook = updateBook
    }
    
    func makeEditBookViewModel() -> EditBookViewModel {
        EditBookViewModel(book: book, updateBook: updateBook)
    }
}
