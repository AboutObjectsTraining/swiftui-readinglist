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
}
