// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

final class Book: ObservableObject, Codable, Identifiable, CustomStringConvertible
{
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case year
        case author
    }
    
    @Published var id = UUID()
    @Published var title: String
    @Published var year: String
    @Published var author: Author
        
    var description: String { "\n\t\t\(id): \(title), \(author)" }
    
    init(title: String = "", year: String = "", author: Author = Author()) {
        self.title = title
        self.year = year
        self.author = author
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        year = try container.decode(String.self, forKey: .year)
        author = try container.decode(Author.self, forKey: .author)
    }
}

// MARK: Encoding
extension Book
{
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(year, forKey: .year)
        try container.encode(author, forKey: .author)
    }
}
