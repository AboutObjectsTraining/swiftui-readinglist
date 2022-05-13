// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

public final class DataStore {
    public static let defaultFileName = "ReadingList"
    public static let fileExtension = "json"
    
    public let fileName: String
    public let bundle: Bundle
    
    public let client: ClientProtocol
    
    private let decoder = JSONDecoder()
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    
    public init(fileName: String = defaultFileName,
                bundle: Bundle = Bundle.main,
                client: ClientProtocol = APIClient()) {
        self.fileName = fileName
        self.bundle = bundle
        self.client = client
        
        copyDefaultFileIfNecessary()
    }
    
    private func copyDefaultFileIfNecessary() {
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.copyItem(at: templateFileURL, to: fileURL)
            } catch {
                fatalError("Unable to copy JSON from app bundle to documents directory.")
            }
        }
    }
}

// MARK: - Operations
extension DataStore {
    
    @MainActor public func fetch() async throws -> ReadingList {
        let data = try await client.fetch(from: fileURL)
        return try decoder.decode(ReadingList.self, from: data)
    }
    
    public func save(readingList: ReadingList) async throws {
        let data = try encoder.encode(readingList)
        try await client.save(data: data, to: fileURL)
    }
}

// MARK: - File URLs
extension DataStore {
    
    var templateFileURL: URL {
        bundle.url(forResource: fileName, withExtension: Self.fileExtension)!
    }
    
    public var fileURL: URL {
        documentsDirectoryURL
            .appendingPathComponent(fileName)
            .appendingPathExtension(Self.fileExtension)
    }
    
    var documentsDirectoryURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first!
    }
}
