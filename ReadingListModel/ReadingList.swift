// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

class ReadingList: ObservableObject, Codable, Identifiable, CustomStringConvertible
{
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case books
    }
    
    @Published var id = UUID()
    @Published var title: String
    @Published var books: [Book]
    
    var description: String { "\n\(ReadingList.self): \n\ttitle: \(title)\n\tbooks: \(books)\n" }
    
    init(title: String, books: [Book]) {
        self.title = title
        self.books = books
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        books = try container.decode([Book].self, forKey: .books)
    }
}

// MARK: Encoding
extension ReadingList
{
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(books, forKey: .books)
    }
}
