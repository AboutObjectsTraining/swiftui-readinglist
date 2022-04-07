// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

class ReadingList: Codable, Identifiable, CustomStringConvertible
{
    var id = UUID()
    var title: String
    var books: [Book]
    
    var description: String { "\n\(ReadingList.self): \n\ttitle: \(title)\n\tbooks: \(books)\n" }
    
    init(title: String, books: [Book]) {
        self.title = title
        self.books = books
    }
}
