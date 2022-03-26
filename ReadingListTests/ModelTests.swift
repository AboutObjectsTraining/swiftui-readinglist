// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import XCTest
import Combine
@testable import ReadingListApp

private let encoder = JSONEncoder()
private let decoder = JSONDecoder()

private var subscriptions: Set<AnyCancellable> = []

private let testData: JsonDictionary = [
    "id": "F345D178-F31B-4D71-9FBD-A684A974A68A",
    "title": "My Summer Reading",
    "books": [
        [
            "id": "02CEF533-3878-4B18-8ECC-97866C9F263E",
            "title": "The Tempest",
            "year": "2012",
            "author": [
                "id": "6338E8F7-10E8-4B68-AF66-200E6430638F",
                "firstName": "William",
                "lastName": "Shakespeare"
            ]
        ],
        [
            "id": "0A251588-A458-4E58-8645-BE923EC53FB7",
            "title": "The Taming of the Shrew",
            "year": "2019",
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
        let book = Book(title: "Gulliver's Travels", year: "2001", author: author)
        
        guard let data = try? encoder.encode(book) else {
            XCTFail("Unable to encode \(book)")
            return
        }
        
        let s = String(data: data, encoding: .utf8)
        print(s!)
    }
    
    func testReadingList() {
        let author = Author(firstName: "William", lastName: "Shakespeare")
        let book1 = Book(title: "The Tempest", year: "2012", author: author)
        let book2 = Book(title: "Julius Ceasar", year: "2019", author: author)
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
        let book1 = Book(title: "The Tempest", year: "2012", author: author)
        let book2 = Book(title: "Julius Ceasar", year: "2019", author: author)
        let readingList = ReadingList(title: "My Summer Reading", books: [book1, book2])
        let store = DataStore(storeName: "TestReadingList", bundle: Bundle(for: type(of: self)))
        
        try! store.save(readingList: readingList)
        XCTAssert(FileManager.default.fileExists(atPath: store.storeFileUrl.path))
        print(store.storeFileUrl.path)
    }
    
    func testDecodeReadingList() throws {
        let data = try! JSONSerialization.data(withJSONObject: testData)
        let readingList = try! decoder.decode(ReadingList.self, from: data)
        print(readingList)
        
        let store = DataStore(storeName: "TestReadingList", bundle: Bundle(for: type(of: self)))
        try! store.save(readingList: readingList)
        
        let fetchedReadingList = try store.fetch()
        print(fetchedReadingList)
        XCTAssertEqual(fetchedReadingList.books.count, 2)
    }
    
    func testDecodeReadingListWithDataTask() {
        let store = DataStore(storeName: "TestReadingList", bundle: Bundle(for: type(of: self)))
        let dataTask = URLSession.shared.dataTask(with: store.storeFileUrl) { data, response, error in
            let readingList = try! decoder.decode(ReadingList.self, from: data!)
            print(readingList)
        }
        
        dataTask.resume()
    }
    
    func testFetchReadingListWithAsyncAwait() async throws {
        let store = DataStore(storeName: "TestReadingList", bundle: Bundle(for: type(of: self)))
        let readingList = try await store.fetchWithAsyncAwait()
        print(readingList)
    }
    
    func testFetchReadingListWithCombine() {
        // FIXME: Not sure why this is currently broken
    
        var readingList: ReadingList?
        
        subscriptions.removeAll()
        
        let store = DataStore(storeName: "TestReadingList", bundle: Bundle(for: type(of: self)))
        let url = store.storeFileUrl
        let publisher = URLSession.shared.dataTaskPublisher(for: url)
        
        publisher
            .breakpointOnError()
            .map { data, response in
                print(response)
                print(String(data: data, encoding: .utf8)!)
                return data
            }
            .breakpointOnError()
            .decode(type: ReadingList.self, decoder: decoder)
            .print()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print("Received completion \(completion)")
            } receiveValue: {
                readingList = $0
            }
            .store(in: &subscriptions)
        
        guard let readingList = readingList else {
            fatalError("Unable to decode ReadingList at url \(store.storeFileUrl)")
        }
        
        print(String(describing: readingList))
    }
}
