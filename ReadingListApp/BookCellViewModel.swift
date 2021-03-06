// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

final class BookCellViewModel: ObservableObject {
    @Published var book: Book
    
    init(book: Book) {
        self.book = book
    }
    
    func makeEditBookViewModel() -> EditBookViewModel {
        EditBookViewModel(book: book)
    }
}
