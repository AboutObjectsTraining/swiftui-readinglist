// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

struct Book: Codable, Identifiable
{
    enum Status: String, Codable {
        case notStarted = "Not Started"
        case inProgress = "In Progress"
        case finished = "Finished"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case year
        case author
        case status
        case percentComplete
    }
    
    var id = UUID()
    var title: String
    var year: String
    var author: Author
    
    var status = Status.notStarted
    var percentComplete = 0.0
    
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
        
        status = try container.decodeIfPresent(Book.Status.self, forKey: .status) ?? .notStarted
        percentComplete = try container.decodeIfPresent(Double.self, forKey: .percentComplete) ?? 0.0
    }
}

// MARK: - Encoding
extension Book
{
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(year, forKey: .year)
        try container.encode(author, forKey: .author)
        
        try container.encode(status, forKey: .status)
        try container.encode(percentComplete, forKey: .percentComplete)
    }
}

extension Book: CustomStringConvertible {
    var description: String { "\n\t\t\(id): \(title), \(author)" }
}
