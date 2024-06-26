// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct ReadingListView: View
{
    @EnvironmentObject var viewModel: ReadingListViewModel
    
    var listOfBooks: some View {
        List {
            ForEach(viewModel.cellViewModels, id: \.book.id) { cellVM in
                BookCell(viewModel: cellVM)
                    .listRowBackground(Color.brown.opacity(0.1))
            }
            .onDelete { indexSet in
                deleteBooks(at: indexSet)
            }
            .onMove { from, to in
                moveBooks(fromOffsets: from, toOffset: to)
            }
        }
        .listStyle(.grouped)
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
                if viewModel.cellViewModels.isEmpty {
                    emptyList
                } else {
                    listOfBooks
                }
            }
            .navigationViewStyle(.automatic)
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
                        .padding(.trailing, 8)
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


#if DEBUG
struct ReadingListPreview: PreviewProvider {
    static var previews: some View {
        Group {
            ReadingListView()
                .environment(\.colorScheme, .dark)
            ReadingListView()
                .environment(\.colorScheme, .light)
        }
        .environmentObject(ReadingListViewModel.loaded)
    }
}
#endif
