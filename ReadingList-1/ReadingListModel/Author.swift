// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

public struct Author: Codable, Identifiable {
    public let id: UUID
    public var firstName: String
    public var lastName: String
    
    /// Designated initializer to use when creating an instance of `Author` programmatically.
    /// - Parameters:
    ///   - id: The author's ID. Defaults to a new instance of `UUID`.
    ///   - firstName: The author's first name. Defaults to blank string.
    ///   - lastName: The author's last name. Defaults to blank string.
    public init(id: UUID = UUID(), firstName: String = "", lastName: String = "") {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
}

extension Author {
    /// Default author name
    static let unknown = "Unknown"
    
    /// Author's full name.
    public var fullName: String {
        switch (firstName, lastName) {
            case ("", ""): return Author.unknown
            case (let name, ""), ("", let name): return name
            default: return "\(firstName) \(lastName)"
        }
    }
}

extension Author: CustomStringConvertible {
    public var description: String {
        fullName
    }
}
