// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct BookCell: View {
    @ObservedObject var viewModel: BookCellViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            InlineImageCell(url: viewModel.book.artworkUrl)
            VStack(alignment: .leading, spacing: 4) {
                Text("\(viewModel.book.title)")
                    .font(.headline)
                    .foregroundColor(Color.green)
                    .padding(.vertical, 3)
                Text("\(viewModel.book.year)  \(viewModel.book.author.fullName)")
                    .font(.subheadline)
                    .padding(.bottom, 10)
            }
            .layoutPriority(1)
            
            NavigationLink {
                EditBookView(viewModel: viewModel.makeEditBookViewModel())
            } label: { }
        }
    }
}

struct InlineImageCell: View {
    let url: URL
    
    var body: some View {
        HStack {
            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 72)
                        .layoutPriority(1)
                } else if phase.error == nil {
                    ProgressView()
                } else {
                    ZStack(alignment: .center) {
                        Color.red
                            .frame(width: 45, height: 72)
                        Image(systemName: "photo.circle")
                            .imageScale(.large)
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}
