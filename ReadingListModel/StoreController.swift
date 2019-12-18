// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

private let encoder: JSONEncoder = {
    let e = JSONEncoder()
    e.outputFormatting = .prettyPrinted
    return e
}()

extension String: Error { }

class StoreController
{
    var storeName = "ReadingList"
    var bundle = Bundle.main
    
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    var storeUrl: URL {
        return documentsUrl.appendingPathComponent(storeName).appendingPathExtension("json")
    }
    
    init() { }
    
    init(storeName: String, bundle: Bundle) {
        self.storeName = storeName
        self.bundle = bundle
    }
    
    func save(readingList: ReadingList) throws {
        guard let data = try? encoder.encode(readingList) else {
            throw "Unable to encode \(readingList)"
        }
        
        do {
            try data.write(to: storeUrl)
        } catch {
            print("Unable to write to \(storeUrl), error was \(error)")
        }
    }
}
