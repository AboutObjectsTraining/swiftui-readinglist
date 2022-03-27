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
                SliderCell(percentComplete: $viewModel.book.percentComplete,
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

struct SliderCell: View {
    @Binding var percentComplete: Double
    let editing: Bool
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            Text("Percent Complete")
                .foregroundColor(.brown.opacity(0.5))
                .font(.caption)
                .padding(.bottom, 0)
            
            if editing {
                Slider(value: $percentComplete, in: (0.0...1.0), step: 0.1)
                    .padding(.vertical, 6)
            } else {
                Text(percentComplete,
                     format: FloatingPointFormatStyle.Percent()
                    .precision(.fractionLength(0))
                )
                .padding(.vertical, 6)
            }
        }
        .listRowBackground(Color.brown.opacity(0.1))
    }
}

struct ImageCell: View {
    let url: URL
    
    var body: some View {
        HStack {
            Spacer()
            Group {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else if phase.error == nil {
                        ProgressView()
                    } else {
                        ZStack(alignment: .center) {
                            Color.red
                                .frame(width: 120)
                            Image(systemName: "photo.circle")
                                .imageScale(.large)
                                .font(.system(size: 44))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .frame(height: 180)
            .shadow(color: .black.opacity(0.5), radius: 12, x: 0, y: 3)
            .padding(.vertical, 18)
            .layoutPriority(1)
            Spacer()
        }
    }
}

struct TextFieldCell: View {
    let title: String
    let isEditing: Bool
    @Binding var value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.brown.opacity(0.5))
                .font(.caption)
                .padding(.bottom, -4)
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
        Group {
            if isEditing {
                content
                    .textFieldStyle(.roundedBorder)
                    .disabled(false)
            } else {
                content
                    .textFieldStyle(.plain)
                    .disabled(true)
            }
        }
        .padding(.bottom, 6)
        .multilineTextAlignment(.leading)
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
