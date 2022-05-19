// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

private let useRealTextField = false

struct EditTitleView: View {
    @EnvironmentObject var viewModel: ReadingListViewModel
    @FocusState var isFocused: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Reading List")) {
                    if useRealTextField {
                        RealTextFieldCell("Title", text: $viewModel.readingList.title)
                            .clearButton(mode: .whileEditing)
                            .autofocused()
                    } else {
                        TextField("Title", text: $viewModel.readingList.title)
                            .textFieldStyle(.automatic)
                            .focused($isFocused)
                            .clearButton(text: $viewModel.readingList.title, isFocused: isFocused)
                    }
                }
            }
            .navigationTitle("Edit Title")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: done, label: { Text("Done") })
                }
            }
            .onAppear {
                if !useRealTextField {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                        isFocused = true
                    }
                }
            }
        }
    }
    
    private func done() {
        viewModel.save()
        viewModel.isEditingTitle = false
    }
}

#if DEBUG
struct EditTitleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditTitleView()
                .environment(\.colorScheme, .light)
            EditTitleView()
                .environment(\.colorScheme, .dark)
            ReadingListView()
        }
        .environmentObject(ReadingListViewModel.loaded)
    }
}
#endif
