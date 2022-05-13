// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

public struct ReadingList: Codable, Identifiable {
    public let id: UUID
    public var title: String
    public private(set) var books: [Book]
    
    public init(id: UUID = UUID(), title: String = "Empty", books: [Book] = []) {
        self.id = id
        self.title = title
        self.books = books
    }
}

extension ReadingList {
    public var count: Int {
        books.count
    }
    
    public mutating func addBook(_ book: Book) {
        books.append(book)
    }
    
    public func book(at index: Int) -> Book? {
        guard (0..<books.count).contains(index) else { return nil }
        return books[index]
    }
}

extension ReadingList: CustomStringConvertible {
    public var description: String {
"""

\(ReadingList.self):
    title: \(title)
    books: \(books)

"""
    }
}
