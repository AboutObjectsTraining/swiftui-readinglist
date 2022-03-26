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
            Section {
                ImageCell(url: viewModel.book.artworkUrl)
            }
            .listRowBackground(Color.clear)
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

struct ImageCell: View {
    let url: URL
    
    var body: some View {
        HStack {
            Spacer()
            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 180)
                        .shadow(color: .black.opacity(0.5), radius: 12, x: 0, y: 3)
                        .padding(.vertical, 18)
                        .layoutPriority(1)
                } else if phase.error == nil {
                    ProgressView()
                } else {
                    Color.red
                }
            }
            Spacer()
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
                .foregroundColor(.brown.opacity(0.5))
            TextField(title, text: $value)
                .conditionalTextFieldStyle(editing: isEditing)
        }
        .listRowBackground(Color.brown.opacity(0.1))
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
                .disabled(false)
        } else {
            content
                .textFieldStyle(.plain)
                .padding(.vertical, 12)
                .multilineTextAlignment(.trailing)
                .disabled(true)
        }
    }
}

struct EditBookView_Preview: PreviewProvider {
    static let author = Author(firstName: "George", lastName: "Orwell")
    static let book = Book(title: "1984", year: "2012", author: author)
    static let viewModel = EditBookViewModel(book: book, updateBook: { _ in })
    
    static var previews: some View {
        NavigationView {
            EditBookView(viewModel: viewModel)
        }
    }
}
