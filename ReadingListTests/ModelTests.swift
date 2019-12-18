// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import XCTest
@testable import ReadingList

let encoder = JSONEncoder()

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
        XCTAssert(FileManager.default.fileExists(atPath: storeController.storeUrl.path))
        print(storeController.storeUrl.path)
    }
}
