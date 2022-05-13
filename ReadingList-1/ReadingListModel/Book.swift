// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

public struct Book: Codable, Identifiable {
    public let id: UUID
    public var title: String
    public var year: Int
    public var author: Author
    
    
    /// Designated initializer to use when creating an instance of `Book` programmatically.
    /// - Parameters:
    ///   - id: The book's ID. Defaults to a new instance of `UUID`.
    ///   - title: The book's title. Defaults to blank string.
    ///   - year: Year the book was published. Defaults to **1999**.
    ///   - author: The book's author. Defaults to  empty instance of `Author`.
    public init(id: UUID = UUID(),
                title: String,
                year: Int = 1999,
                author: Author = Author()) {
        self.id = id
        self.title = title
        self.year = year
        self.author = author
    }
}

extension Book: CustomStringConvertible {
    public var description: String { "\n\t\ttitle: \(title), author: \(author), UUID: \(id)" }
}
