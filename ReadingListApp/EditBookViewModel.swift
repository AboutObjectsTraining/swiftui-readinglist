// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

final class EditBookViewModel: ObservableObject {
    @Published var book: Book
    @Published var isEditing = false
    
    init(book: Book) {
        self.book = book
    }
}
