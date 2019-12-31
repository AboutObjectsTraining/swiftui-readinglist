// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct ReadingListView: View
{
    @ObservedObject var storeController = StoreController(storeName: "ReadingList", bundle: Bundle.main)
    @State var isAddingCell = false
    
    var readingList: ReadingList { storeController.fetchedReadingList }
    var books: [Book] { readingList.books }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(readingList.books) {
                    BookCell(book: $0)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text(readingList.title))
            .navigationBarItems(leading: Button(action: addCell) { Image(systemName: "plus") },
                                trailing: EditButton())
        }
        .sheet(isPresented: $isAddingCell, onDismiss: {
            print("TODO: Add cell")
        }) {
            VStack {
                HStack {
                    Button(action: { self.isAddingCell = false }, label: { Text("Cancel") })
                    Spacer()
                    Button(action: { self.isAddingCell = false }, label: { Text("Done") })
                }
                .padding(18.0)
                Spacer()
                Text("Add Cell Form")
                Spacer()
            }
        }
    }
    
    func addCell() {
        print("Adding cell...")
        isAddingCell = true
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

