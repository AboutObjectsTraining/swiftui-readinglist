// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct ReadingListView: View {
    @EnvironmentObject var viewModel: ReadingListViewModel
    
    @State var loadFailed = false

    var emptyView: some View {
        Text("This reading list doesn't contain any books.")
            .font(.system(size: 24, weight: .medium).italic())
            .foregroundColor(.secondary)
            .padding(30)
    }
    var listView: some View {
        List(viewModel.readingList.books) { book in
//            Text("\(book.title)")
            BookCell(book: book)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isEmpty {
                    emptyView
                } else {
                    listView
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.tertiary)
            .navigationTitle("My Reading List")
            .onAppear(perform: loadReadingList)
            .alert("Unable to load reading list.", isPresented: $loadFailed) {
                Button("Okay", role: .cancel) { }
            }
        }
    }
    
    func loadReadingList() {
        Task {
            do {
                try await viewModel.loadReadingListIfEmpty()
            } catch {
                showAlert()
            }
        }
    }
    
    func showAlert() {
        loadFailed = true
    }
}

#if DEBUG
struct ReadingListView_Previews: PreviewProvider {
    static let viewModel = ReadingListViewModel()
    static var previews: some View {
        Group {
            ReadingListView()
            ReadingListView()
                .preferredColorScheme(.dark)
        }
        .environmentObject(viewModel)
    }
}
#endif
