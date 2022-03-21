// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct AddBookView: View {
    @EnvironmentObject var viewModel: ReadingListViewModel
    @State var book = Book()
        
    var body: some View {
        NavigationView {
            Form {
                Group {
                    AddBookCell(title: "Title", placeholder: "The Tempest", text: $book.title)
                    AddBookCell(title: "Year", placeholder: "1999", text: $book.year)
                    AddBookCell(title: "First Name", placeholder: "William", text: $book.author.firstName)
                    AddBookCell(title: "Last Name", placeholder: "Shakespeare", text: $book.author.lastName)
                }
                .listRowSeparator(.hidden)
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
                Text(title)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 100)
                TextField(placeholder, text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .clearButton(text: $text)
            }
            .padding(.vertical, 4.0)
        }
    }
}

extension View {
    func clearButton(text: Binding<String>) -> some View {
        modifier(ClearButton(text: text))
    }
}

struct ClearButton: ViewModifier {
    @Binding var text: String
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content
            if !text.isEmpty {
                Button(
                    action: {
                        self.text = ""
                    },
                    label: {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(Color(UIColor.opaqueSeparator))
                    }
                )
                .padding(.trailing, 8)
            }
        }
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
