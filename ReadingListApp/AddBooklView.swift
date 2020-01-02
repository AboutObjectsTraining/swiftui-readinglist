// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct AddBookView: View {
    @Binding var isAddingCell: Bool
    @ObservedObject var book = Book(title: "", year: "", author: Author(firstName: "", lastName: ""))
        
    var body: some View {
        NavigationView {
            List {
                AddBookCell(title: "Title", placeholder: "The Tempest", text: $book.title)
                AddBookCell(title: "Year", placeholder: "1999", text: $book.year)
                AddBookCell(title: "First Name", placeholder: "William", text: $book.author.firstName)
                AddBookCell(title: "Last Name", placeholder: "Shakespeare", text: $book.author.lastName)
            }
            .listStyle(GroupedListStyle())
            .foregroundColor(.secondary)
            .navigationBarItems(leading: Button(action: { self.isAddingCell = false }) { Text("Cancel") },
                                trailing: Button(action: { self.isAddingCell = false }) { Text("Done") })
        }
    }
    
    init(isAddingCell: Binding<Bool>) {
        self._isAddingCell = isAddingCell
        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().selectionStyle = .none
    }
}

struct AddBookCell: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack() {
            Group {
                Text(title).multilineTextAlignment(.trailing).frame(width: 100)
                TextField(placeholder, text: $text).textFieldStyle(RoundedBorderTextFieldStyle())
                    .modifier(ClearButton(text: $text))
            }
            .padding(.vertical, 4.0)
        }
    }
}

struct ClearButton: ViewModifier
{
    @Binding var text: String
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content
            if !text.isEmpty {
                Button(action: { self.text = "" }) {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(Color(UIColor.opaqueSeparator))
                }
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
            AddBookView(isAddingCell: readingListView.$isAddingCell)
                .environment(\.colorScheme, .dark)
            AddBookView(isAddingCell: readingListView.$isAddingCell)
        }
    }
}
#endif
