// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct ReadingListView: View
{
    @EnvironmentObject var viewModel: ReadingListViewModel
    
    var listOfBooks: some View {
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
        .padding(.top, 20)
    }
    
    var emptyList: some View {
        HStack(alignment: .center) {
            Text("This reading list doesn't have any books yet.")
                .padding(.horizontal, 40)
                .multilineTextAlignment(.center)
                .font(.title2.italic())
                .foregroundColor(.secondary)
        }
    }
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.books.isEmpty {
                    emptyList
                } else {
                    listOfBooks
                }
            }
            .navigationBarTitle(Text(viewModel.readingList.title))
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: showAddBookView,
                           label: { Image(systemName: "plus") })
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: editTitle,
                           label: { Image(systemName: "square.and.pencil") })
                    EditButton()
                }
            }
        }
        .onAppear { viewModel.loadIfEmpty() }
        .sheet(isPresented: $viewModel.isEditingTitle, content: { EditTitleView() })
        .sheet(isPresented: $viewModel.isAddingBook,   content: { AddBookView() })
    }
}

// MARK: - Actions
extension ReadingListView {

    private func editTitle() {
        viewModel.isEditingTitle = true
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

struct EditTitleView: View {
    @EnvironmentObject var viewModel: ReadingListViewModel
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $viewModel.readingList.title)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.top, 40)
            .navigationTitle("Edit Title")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: done, label: { Text("Done") })
                }
            }
        }
    }
    
    private func done() {
        viewModel.save()
        viewModel.isEditingTitle = false
    }
}

#if DEBUG
struct ReadingListPreview: PreviewProvider {
    static var previews: some View {
        Group {
//            ReadingListView()
//                .environment(\.colorScheme, .dark)
//                .environmentObject(ReadingListViewModel.empty)
            EditTitleView()
                .environment(\.colorScheme, .dark)
                .environmentObject(ReadingListViewModel.loaded)
            ReadingListView()
                .environment(\.colorScheme, .dark)
                .environmentObject(ReadingListViewModel.empty)
            ReadingListView()
                .environment(\.colorScheme, .light)
                .environmentObject(ReadingListViewModel.empty)
        }
    }
}
#endif
