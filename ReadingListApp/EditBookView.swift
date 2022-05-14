// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct EditBookView: View {
    @EnvironmentObject var readingListViewModel: ReadingListViewModel
    @ObservedObject var viewModel: EditBookViewModel
    
    @State var isShowingImagePicker = false
    @State var newCoverImage: UIImage?
    
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
                Group {
                    if let newCoverImage = newCoverImage {
                        ImageCell(url: viewModel.book.artworkUrl,
                                  isEditing: viewModel.isEditing,
                                  image: Image(uiImage: newCoverImage))
                    } else {
                        ImageCell(url: viewModel.book.artworkUrl,
                                  isEditing: viewModel.isEditing)
                    }
                }
                .onTapGesture(perform: showImagePicker)
            }
            .listRowBackground(Color.clear)
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(image: $newCoverImage)
            }
            .onChange(of: newCoverImage) { newValue in
                
            }
        }
        .navigationTitle("Book Details")
        .navigationBarBackButtonHidden(viewModel.isEditing)
        .toolbar {
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
    
    init(viewModel: EditBookViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - Intents
extension EditBookView {
    
    private func edit() {
        withAnimation(.easeInOut(duration: 0.2)) {
            viewModel.isEditing.toggle()
        }
        
        if !viewModel.isEditing {
            readingListViewModel.update(book: viewModel.book)
        }
    }
    
    private func showImagePicker() {
        if viewModel.isEditing {
            isShowingImagePicker = true
        }
    }
}

// TODO: Migrate to separate file
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

struct EditBookView_Preview: PreviewProvider {
    static let author = Author(firstName: "George", lastName: "Orwell")
    static let book = Book(title: "1984", year: "2012", author: author)
    static let viewModel = EditBookViewModel(book: book)
    
    static var previews: some View {
        NavigationView {
            EditBookView(viewModel: viewModel)
        }
    }
}
