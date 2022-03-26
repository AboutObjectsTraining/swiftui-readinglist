// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct EditBookView: View {
    @ObservedObject var viewModel: EditBookViewModel
    
    var body: some View {
        Form {
            Section("Book") {
                TextFieldCell("Title",
                              value: $viewModel.book.title,
                              editing: viewModel.isEditing)
                TextFieldCell("Year",
                              value: $viewModel.book.year,
                              editing: viewModel.isEditing)
            }
            Section("Author") {
                TextFieldCell("First Name",
                              value: $viewModel.book.author.firstName,
                              editing: viewModel.isEditing)
                TextFieldCell("Last Name",
                              value: $viewModel.book.author.lastName,
                              editing: viewModel.isEditing)
            }
        }
        .navigationTitle("Book Details")
        .navigationBarBackButtonHidden(viewModel.isEditing)
        .toolbar {
            ToolbarItem {
                Button(
                    action: edit,
                    label: {
                        Text(viewModel.isEditing ? "Done" : "Edit" )
                            .fontWeight(viewModel.isEditing ? .semibold : .regular)
                    }
                )
                .padding(.horizontal, 8)
            }
        }
    }
    
    init(viewModel: EditBookViewModel) {
        self.viewModel = viewModel
    }
    
    private func edit() {
        withAnimation(.easeInOut(duration: 0.3)) {
            viewModel.isEditing.toggle()
        }
        
        if !viewModel.isEditing {
            viewModel.update()
        }
    }
}

struct TextFieldCell: View {
    let title: String
    let isEditing: Bool
    @Binding var value: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(title)
            TextField(title, text: $value)
                .conditionalTextFieldStyle(editing: isEditing)
        }
    }
    
    init(_ title: String, value: Binding<String>, editing: Bool) {
        self.title = title
        self.isEditing = editing
        _value = value
    }
}

extension View {
    func conditionalTextFieldStyle(editing: Bool) -> some View {
        modifier(ConditionalTextFieldStyle(isEditing: editing))
    }
}

struct ConditionalTextFieldStyle: ViewModifier {
    let isEditing: Bool
    
    func body(content: Content) -> some View {
        if isEditing {
            content
                .textFieldStyle(.roundedBorder)
                .padding(.vertical, 6)
                .multilineTextAlignment(.leading)
        } else {
            content
                .textFieldStyle(.plain)
                .padding(.vertical, 12)
                .multilineTextAlignment(.trailing)
        }
    }
}

struct EditBookView_Preview: PreviewProvider {
    static let author = Author(firstName: "Fred", lastName: "Smith")
    static let book = Book(title: "Some Title", year: "1999", author: author)
    static let viewModel = EditBookViewModel(book: book, updateBook: { _ in })
    
    static var previews: some View {
        NavigationView {
            EditBookView(viewModel: viewModel)
        }
    }
}
