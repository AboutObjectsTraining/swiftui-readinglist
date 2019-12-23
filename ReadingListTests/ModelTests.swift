// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import XCTest
@testable import ReadingList

private let encoder = JSONEncoder()
private let decoder = JSONDecoder()

private let testData: JsonDictionary = [
    "id": "F345D178-F31B-4D71-9FBD-A684A974A68A",
    "title": "My Summer Reading",
    "books": [
        [
            "id": "02CEF533-3878-4B18-8ECC-97866C9F263E",
            "title": "The Tempest",
            "author": [
                "id": "6338E8F7-10E8-4B68-AF66-200E6430638F",
                "firstName": "William",
                "lastName": "Shakespeare"
            ]
        ],
        [
            "id": "0A251588-A458-4E58-8645-BE923EC53FB7",
            "title": "The Taming of the Shrew",
            "author": [
                "id": "6338E8F7-10E8-4B68-AF66-200E6430638F",
                "firstName": "William",
                "lastName": "Shakespeare"
            ]
        ]
    ]
]

class ModelTests: XCTestCase {
    
    func testAuthor() {
        let author = Author(firstName: "Jonathan", lastName: "Swift")

        guard let data = try? encoder.encode(author) else {
            XCTFail("Unable to encode \(author)")
            return
        }
        
        let s = String(data: data, encoding: .utf8)
        print(s!)
    }
    
    func testBook() {
        let author = Author(firstName: "Jonathan", lastName: "Swift")
        let book = Book(title: "Gulliver's Travels", author: author)
        
        guard let data = try? encoder.encode(book) else {
            XCTFail("Unable to encode \(book)")
            return
        }
        
        let s = String(data: data, encoding: .utf8)
        print(s!)
    }
    
    func testReadingList() {
        let author = Author(firstName: "William", lastName: "Shakespeare")
        let book1 = Book(title: "The Tempest", author: author)
        let book2 = Book(title: "Julius Ceasar", author: author)
        let readingList = ReadingList(title: "My Summer Reading", books: [book1, book2])
        
        guard let data = try? encoder.encode(readingList) else {
            XCTFail("Unable to encode \(readingList)")
            return
        }
        
        let s = String(data: data, encoding: .utf8)
        print(s!)
        print(Bundle.main.bundlePath)
        print(Bundle(for: type(of: self)))
    }
    
    func testSaveReadingList() {
        let author = Author(firstName: "William", lastName: "Shakespeare")
        let book1 = Book(title: "The Tempest", author: author)
        let book2 = Book(title: "Julius Ceasar", author: author)
        let readingList = ReadingList(title: "My Summer Reading", books: [book1, book2])
        let storeController = StoreController(storeName: "TestReadingList", bundle: Bundle(for: type(of: self)))
        
        try! storeController.save(readingList: readingList)
        XCTAssert(FileManager.default.fileExists(atPath: storeController.storeFileUrl.path))
        print(storeController.storeFileUrl.path)
    }
    
    func testDecodeReadingList() {
        let data = try! JSONSerialization.data(withJSONObject: testData)
        let readingList = try! decoder.decode(ReadingList.self, from: data)
        print(readingList)
        
        let storeController = StoreController(storeName: "TestReadingList", bundle: Bundle(for: type(of: self)))
        try! storeController.save(readingList: readingList)
        
        let fetchedReadingList = storeController.fetchedReadingList
        print(fetchedReadingList)
        XCTAssertEqual(fetchedReadingList.books.count, 2)
    }
}
