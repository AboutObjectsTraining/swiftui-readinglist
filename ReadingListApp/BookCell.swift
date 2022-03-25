// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct BookCell: View {
    @ObservedObject var viewModel: BookCellViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(viewModel.book.title)")
                    .font(.headline)
                    .foregroundColor(Color.green)
                    .padding(.vertical, 6)
                Text("\(viewModel.book.year) | \(viewModel.book.author.fullName)")
                    .font(.subheadline)
                    .padding(.bottom, 10)
            }
            .layoutPriority(1)
            
            NavigationLink {
                EditBookView(viewModel: EditBookViewModel(book: viewModel.book))
            } label: { }
        }
    }
}
