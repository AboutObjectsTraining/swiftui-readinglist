// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import XCTest
@testable import ReadingListModel

class ReadingListModelTests: XCTestCase {

    func testCreateBook() {
        let title = "My Book"
        let book = Book(title: title)
        print(book)
        XCTAssertEqual(title, book.title)
        XCTAssertEqual(1999, book.year)
        XCTAssertEqual("", book.author.firstName)
    }

    func testCreateReadingList() {
        let title1 = "Book 1"
        let book1 = Book(title: title1)
        let title2 = "Book 2"
        let book2 = Book(title: title2)
        var readingList = ReadingList(title: "My Reading List")
        readingList.addBook(book1)
        readingList.addBook(book2)
        print(readingList)
        
        XCTAssertEqual(readingList.book(at: 0)?.id, book1.id)
        XCTAssertEqual(readingList.book(at: 1)?.id, book2.id)
        XCTAssertEqual(readingList.count, 2)
    }
    
    func testAsyncSave() async throws {
        let text = "Hello World!\n"
        let data = text.data(using: .utf8)
        let url = URL(fileURLWithPath: "/tmp/test-async-save")
        
        try await APIClient().save(data: data!, to: url)
        
        let savedText = try! String(contentsOf: url)
        XCTAssertEqual(savedText, text)
    }
    
    func testAsyncFetch() async throws {
        let text = "Async fetch data.\n"
        let url = URL(fileURLWithPath: "/tmp/test-async-fetch")
        try! text.write(to: url, atomically: true, encoding: .utf8)
        
        let data = try await APIClient().fetch(from: url)
        
        let fetchedText = String(data: data, encoding: .utf8)
        XCTAssertEqual(fetchedText, text)
    }
    
    func testAsyncSaveReadingList() async throws {
        let author = Author(firstName: "William", lastName: "Shakespeare")
        let book1 = Book(title: "The Tempest", year: 2012, author: author)
        let book2 = Book(title: "Julius Caeser", year: 2019, author: author)
        let readingList = ReadingList(title: "My Summer Reading", books: [book1, book2])
        let store = DataStore(fileName: "TestReadingList", bundle: Bundle(for: type(of: self)))
        
        try! await store.save(readingList: readingList)
        
        XCTAssert(FileManager.default.fileExists(atPath: store.fileURL.path))
        print(store.fileURL.path)
    }
    
    func testDecodeBook() throws {
        let data = bookJSON.data(using: .utf8)!
        let book = try JSONDecoder().decode(Book.self, from: data)
        print(book)
        XCTAssertEqual(book.year, 2012)
    }
}

let bookJSON = """
{
  "status" : "Not Started",
  "id" : "02CEF533-3878-4B18-8ECC-97866C9F263E",
  "title" : "Julius Caesar",
  "author" : {
    "id" : "6338E8F7-10E8-4B68-AF66-200E6430638F",
    "firstName" : "William",
    "lastName" : "Shakespeare"
  },
  "year" : 2012,
}
"""
