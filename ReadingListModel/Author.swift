// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

struct Author: Codable, Identifiable, CustomStringConvertible
{
    var id = UUID()
    var firstName: String
    var lastName: String
    
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
    
    var description: String { fullName }
    
    init(firstName: String? = nil, lastName: String? = nil) {
        self.firstName = firstName ?? ""
        self.lastName = lastName ?? ""
    }
}
