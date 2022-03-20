// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

final class Author: ObservableObject, Codable, Identifiable, CustomStringConvertible
{
    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
    }
    
    @Published var id = UUID()
    @Published var firstName: String
    @Published var lastName: String
    
    static let unknown = "Unknown"
    
    static func == (lhs: Author, rhs: Author) -> Bool {
        return lhs.id == rhs.id
    }

    var fullName: String {
        switch (firstName, lastName) {
            case ("", ""): return Author.unknown
            case (let name, ""), ("", let name): return name
            default: return "\(firstName) \(lastName)"
        }
    }

//    var fullName: String {
//        switch (firstName, lastName) {
//            case (nil, nil): return Author.unknown
//            case (let name?, nil), (nil, let name?): return name
//            default: return "\(firstName!) \(lastName!)"
//        }
//    }
    
    var description: String { fullName }
    
    init(firstName: String? = nil, lastName: String? = nil) {
        self.firstName = firstName ?? ""
        self.lastName = lastName ?? ""
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
    }
}

// MARK: Encoding
extension Author
{
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
    }
}
