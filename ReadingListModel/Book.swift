// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

class Book: Codable, Identifiable, CustomStringConvertible
{
    var id = UUID()
    var title: String
    var author: Author
    
    var description: String { "\n\t\t\(id): \(title), \(author)" }
    
    init(title: String, author: Author) {
        self.title = title
        self.author = author
    }
}
