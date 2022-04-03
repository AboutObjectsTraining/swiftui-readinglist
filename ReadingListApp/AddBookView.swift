// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct AddBookView: View {
    @EnvironmentObject var viewModel: ReadingListViewModel
    @State var book = Book()
        
    var body: some View {
        NavigationView {
            Form {
                Section {
                    AddBookCell(title: "Title",
                                placeholder: "The Tempest",
                                text: $book.title)
                    AddBookCell(title: "Year",
                                placeholder: "1999",
                                text: $book.year)
                    .keyboardType(.numberPad)
                    AddBookCell(title: "First Name",
                                placeholder: "William",
                                text: $book.author.firstName)
                    AddBookCell(title: "Last Name",
                                placeholder: "Shakespeare",
                                text: $book.author.lastName)
                }
                .listRowSeparator(.hidden)
                .buttonStyle(.plain)
                .navigationTitle("Add Book")
            }
            .interactiveDismissDisabled()
            .foregroundColor(.secondary)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: cancel,
                           label: { Text("Cancel") })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addBook,
                           label: { Text("Done") })
                }
            }
        }
    }
    
    private func addBook() {
        viewModel.addBook(book)
        viewModel.isAddingBook = false
    }
    
    private func cancel() {
        viewModel.isAddingBook = false
    }
}

struct AddBookCell: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack() {
            Group {
                HStack {
                    Spacer()
                    Text(title)
                }
                .frame(width: 92)
                TextFieldWithClearButton(placeholder: placeholder,
                                         text: $text)
            }
            .padding(.vertical, 4.0)
        }
        .padding(.leading, -10)
    }
}

#if DEBUG
struct AddBookViewPreviews: PreviewProvider {
    static var readingListView = ReadingListView()
    static var previews: some View {
        Group {
            AddBookView()
                .environment(\.colorScheme, .dark)
            AddBookView()
        }
    }
}
#endif
