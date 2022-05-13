// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

public protocol ClientProtocol {
    
    func fetch(from url: URL) async throws -> Data
    
    func save(data: Data, to url: URL) async throws
}


public struct APIClient: ClientProtocol {
    
    public init() { }
    
    public func fetch(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    public func save(data: Data, to url: URL) async throws {
        Task.detached(priority: .userInitiated) {
            do {
                try data.write(to: url)
            } catch {
                throw StorageError.unableToSave(message: "Unable to write to \(url), error was \(error)")
            }
        }
    }
}

// MARK: - URLSession upload example

extension APIClient {
    
    public func upload(data: Data, to url: URL) async throws {
        let request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalCacheData)
        let (_, response) = try await URLSession.shared.upload(for: request, from: data)
        
        if let response = response as? HTTPURLResponse, response.statusCode != 200 {
            throw StorageError.unableToSave(message: "Unable to save; response code was \(response.statusCode)")
        }
    }
}
