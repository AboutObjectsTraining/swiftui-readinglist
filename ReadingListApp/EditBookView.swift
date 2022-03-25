// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct EditBookView: View {
    @EnvironmentObject var readingListViewModel: ReadingListViewModel
    @ObservedObject var viewModel: EditBookViewModel
    
    @State private var isEditing = false
    
    var body: some View {
        Form {
            Section("Book") {
                TextFieldCell(title: "Title", value: $viewModel.book.title)
                TextFieldCell(title: "Year", value: $viewModel.book.year)
            }
            Section("Author") {
                TextFieldCell(title: "First Name", value: $viewModel.book.author.firstName)
                TextFieldCell(title: "Last Name", value: $viewModel.book.author.lastName)
            }
        }
        .disabled(!isEditing)
        .navigationTitle("Book Details")
        .navigationBarBackButtonHidden(isEditing)
        .toolbar {
            ToolbarItem {
                Button(
                    action: edit,
                    label: { Text(isEditing ? "Done" : "Edit" )}
                )
            }
        }
    }
    
    init(viewModel: EditBookViewModel) {
        self.viewModel = viewModel
    }
    
    private func edit() {
        isEditing.toggle()
        if !isEditing {
            readingListViewModel.update(book: viewModel.book)
        }
    }
}

struct TextFieldCell: View {
    let title: String
    @Binding var value: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(title)
            TextField(title, text: $value)
                .textFieldStyle(.roundedBorder)
                .padding(.vertical, 12)
        }
    }
}
