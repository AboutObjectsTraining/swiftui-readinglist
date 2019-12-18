// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

class Author: Codable, Identifiable
{
    var id = UUID()
    var firstName: String?
    var lastName: String?
    
    static let unknown = "Unknown"
    
    static func == (lhs: Author, rhs: Author) -> Bool {
        return lhs.id == rhs.id
    }
    
    var fullName: String {
        switch (firstName, lastName) {
            case (nil, nil): return Author.unknown
            case (let name?, nil), (nil, let name?): return name
            default: return "\(firstName!) \(lastName!)"
        }
    }
    
    init(firstName: String?, lastName: String?) {
        self.firstName = firstName
        self.lastName = lastName
    }
}
