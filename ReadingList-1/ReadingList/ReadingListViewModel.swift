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
    
    func loadReadingListIfEmpty() async throws {
        self.readingList = try await self.dataStore.fetch()
    }
}
