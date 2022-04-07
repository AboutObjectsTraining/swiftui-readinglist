// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation
import Combine

typealias JsonDictionary = [String: Any]

private let encoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    return encoder
}()

private let decoder = JSONDecoder()
private let defaultStoreName = "ReadingList"

private var subscriptions: Set<AnyCancellable> = []

extension String: Error { }

enum StoreError: Error {
    case unableToEncode(message: String)
    case unableToDecode(message: String)
    case unableToSave(message: String)
}

final class DataStore
{
    let storeType = "json"
    let storeName: String
    var bundle: Bundle
    
    var documentsDirectoryUrl: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    var storeFileUrl: URL {
        documentsDirectoryUrl.appendingPathComponent(storeName).appendingPathExtension(storeType)
    }
    var templateStoreFileUrl: URL {
        bundle.url(forResource: storeName, withExtension: storeType)!
    }
    
    init(storeName: String = defaultStoreName, bundle: Bundle = Bundle.main) {
        self.storeName = storeName
        self.bundle = bundle
        copyStoreFileIfNecessary()
    }
    
    func copyStoreFileIfNecessary() {
        if !FileManager.default.fileExists(atPath: storeFileUrl.path) {
            try! FileManager.default.copyItem(at: templateStoreFileUrl, to: storeFileUrl)
        }
    }
}

// MARK: - File-based operations
extension DataStore {
    
    func fetch() throws -> ReadingList {
        guard
            let data = try? Data(contentsOf: storeFileUrl),
            let readingList = try? decoder.decode(ReadingList.self, from: data) else {
            throw StoreError.unableToDecode(message: "Unable to decode ReadingList at url \(storeFileUrl)")
        }
        return readingList
    }
    
    func save(readingList: ReadingList) throws {
        guard let data = try? encoder.encode(readingList) else {
            throw StoreError.unableToEncode(message: "Unable to encode \(readingList)")
        }
        
        do {
            try data.write(to: storeFileUrl)
        } catch {
            throw StoreError.unableToSave(message: "Unable to write to \(storeFileUrl), error was \(error)")
        }
    }
}

// MARK: - URLSession-based operations
extension DataStore {
    
    func fetchWithCombine(callback: @escaping (ReadingList) -> Void) throws -> Void {

        subscriptions.removeAll()
        
        URLSession.shared.dataTaskPublisher(for: storeFileUrl)
            .map { data, response -> Data in
                print("In tryMap: response was \(response)")
                print(String(data: data, encoding: .utf8)!)
                return data
            }
            .decode(type: ReadingList.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print(completion)
            } receiveValue: { readingList in
                callback(readingList)
            }
            .store(in: &subscriptions)
    }
    
    @MainActor func fetchWithAsyncAwait() async throws -> ReadingList {
        let (data, _) = try await URLSession.shared.data(from: storeFileUrl)
        return try JSONDecoder().decode(ReadingList.self, from: data)
    }
}
