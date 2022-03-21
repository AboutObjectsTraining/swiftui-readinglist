// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct ReadingListView: View
{
    @EnvironmentObject var viewModel: ReadingListViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.books) {
                    BookCell(book: $0)
                }
                .onDelete { indexSet in
                    deleteBooks(at: indexSet)
                }
                .onMove { from, to in
                    moveBooks(fromOffsets: from, toOffset: to)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text(viewModel.readingList.title))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: showAddBookView,
                           label: { Image(systemName: "plus") })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
        .sheet(
            isPresented: $viewModel.isAddingBook,
            content: { AddBookView() }
        )
    }
    
    private func showAddBookView() {
        viewModel.isAddingBook = true
    }
    
    private func deleteBooks(at indexSet: IndexSet) {
        viewModel.deleteBooks(at: indexSet)
    }
    
    func moveBooks(fromOffsets: IndexSet, toOffset: Int) {
        viewModel.moveBooks(fromOffsets: fromOffsets, toOffset: toOffset)
    }
}

struct BookCell: View {
    let book: Book
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(book.title)")
                .font(.headline)
                .foregroundColor(Color.green)
            Text("\(book.year) | \(book.author.fullName)")
                .font(.subheadline)
                .padding(.bottom, 6.0)
        }
    }
}

#if DEBUG
struct ReadingListPreview: PreviewProvider {
    static var previews: some View {
        Group {
            ReadingListView()
                .environment(\.colorScheme, .dark)
            ReadingListView()
                .environment(\.colorScheme, .light)
        }
    }
}
#endif
