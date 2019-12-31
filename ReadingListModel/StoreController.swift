// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

typealias JsonDictionary = [String: Any]

private let encoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    return encoder
}()

private let decoder = JSONDecoder()

extension String: Error { }

class StoreController: ObservableObject
{
    var storeName = "ReadingList"
    var bundle = Bundle.main
    
    var documentsDirectoryUrl: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    var storeFileUrl: URL {
        documentsDirectoryUrl.appendingPathComponent(storeName).appendingPathExtension("json")
    }
    var templateStoreFileUrl: URL {
        bundle.url(forResource: storeName, withExtension: "json")!
    }
    
    var fetchedReadingList: ReadingList {
        guard
            let data = try? Data(contentsOf: storeFileUrl),
            let readingList = try? decoder.decode(ReadingList.self, from: data) else {
            fatalError("Unable to decode ReadingList at url \(storeFileUrl)")
        }
        return readingList
    }
    
    init() { }
    
    init(storeName: String, bundle: Bundle) {
        self.storeName = storeName
        self.bundle = bundle
        copyStoreFileIfNecessary()
    }
    
    func copyStoreFileIfNecessary() {
        if !FileManager.default.fileExists(atPath: storeFileUrl.path) {
            try! FileManager.default.copyItem(at: templateStoreFileUrl, to: storeFileUrl)
        }
    }
    
    func save(readingList: ReadingList) throws {
        guard let data = try? encoder.encode(readingList) else {
            throw "Unable to encode \(readingList)"
        }
        
        do {
            try data.write(to: storeFileUrl)
        } catch {
            print("Unable to write to \(storeFileUrl), error was \(error)")
        }
    }
}
