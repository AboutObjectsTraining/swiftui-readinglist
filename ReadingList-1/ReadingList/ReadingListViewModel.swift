// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI
import ReadingListModel
import Combine

final class ReadingListViewModel: ObservableObject {
    private var subscriptions: Set<AnyCancellable> = []
    private let dataStore: DataStore
    
    @Published var readingList = ReadingList()
    @Published var isEmpty = true
    
    @Published var loadFailed = false
    
    init(dataStore: DataStore = DataStore()) {
        self.dataStore = dataStore
        configurePublishers()
    }
    
    private func configurePublishers() {
        $readingList
            .sink { readingList in
                self.isEmpty = readingList.books.isEmpty
            }
            .store(in: &subscriptions)
    }
}

extension ReadingListViewModel {
    
    func loadReadingListIfEmptyOriginal() async throws {
        readingList = try await self.dataStore.fetch()
    }

    func loadReadingListIfEmpty() async {
        do {
            readingList = try await self.dataStore.fetch()
        } catch {
            loadFailed = true
        }
    }
}

extension Book {
    var formattedYear: String {
        year.description
    }
    
    var artworkUrl: URL {
        let title = title.trimmingCharacters(in: .whitespaces)
        let name = title.isEmpty ? "unknown" : title
        let url = Bundle.main.path(forResource: name, ofType: "jpg") ?? ""
        return URL(fileURLWithPath: url)
    }
}

