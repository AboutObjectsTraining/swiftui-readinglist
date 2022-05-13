// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI
import ReadingListModel

struct BookCell: View {
    let book: Book
    
    var overview: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(book.title)")
                .font(.headline)
                .foregroundColor(.green)
            HStack {
                Text("\(book.formattedYear)")
                Text("\(book.author.fullName)")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
    }
    
    var body: some View {
        HStack(spacing: 18) {
            ThumbnailImage(url: book.artworkUrl)
            
            overview
                .layoutPriority(1)
            
            NavigationLink("") {
                // TODO: Implement detail view
                Text("\(book.title)")
                    .navigationTitle("Book Detail")
            }
        }
    }
}

struct ThumbnailImage: View {
    let url: URL
    
    var body: some View {
        AsyncImage(url: url) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: Configuration.height)
                    .layoutPriority(1)
            } else if phase.error == nil {
                ProgressView()
            } else {
                ZStack(alignment: .center) {
                    Color.orange
                        .frame(width: Configuration.width, height: Configuration.height)
                    Image(systemName: "photo.circle")
                        .imageScale(.large)
                        .font(.system(size: Configuration.symbolSize))
                        .foregroundColor(.white)
                }
            }
        }
        .shadow(color: .black.opacity(0.5), radius: 6, x: 0, y: 0)
    }
    
    struct Configuration {
        static var width: CGFloat = 48
        static var height: CGFloat = 72
        static var symbolSize: CGFloat = 25
    }
}

#if DEBUG
struct BookCell_Previews: PreviewProvider {
    static let viewModel = ReadingListViewModel()
    
    static var previews: some View {
        Group {
            BookCell(book: TestData.book)
            
            BookCell(book: TestData.bookWithMissingImage)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.fixed(width: 340, height: 70))
        
        ReadingListView()
            .environmentObject(viewModel)
    }
}
#endif
