// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import ReadingListModel

#if DEBUG
struct TestData {
    static var book: Book {
        Book(title: "Julius Caesar",
             year: 1999,
             author: Author(firstName: "William", lastName: "Shakespeare"))
    }
    
    static var bookWithMissingImage: Book {
        Book(title: "The Tempest",
             year: 1999,
             author: Author(firstName: "William", lastName: "Shakespeare"))
    }
}
#endif
