// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct ImageCell: View {
    let url: URL
    let isEditing: Bool
    
    var image: Image?
    
    var asyncImage: some View {
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
    
    var body: some View {
        HStack {
            Spacer()
            
            Group {
                if image == nil {
                    asyncImage
                } else if let image = image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .frame(height: 180)
            .border(.blue, width: isEditing ? 4 : 0)
            .shadow(color: isEditing ? .clear : .secondary, radius: 12, x: 0, y: 3)
            .padding(.vertical, 18)
            .layoutPriority(1)
            
            Spacer()
        }
    }
    
    init(url: URL, isEditing: Bool = false, image: Image? = nil) {
        self.url = url
        self.isEditing = isEditing
        self.image = image
    }
}

#if DEBUG
struct ImageCell_Previews: PreviewProvider {
    static let author = Author(firstName: "George", lastName: "Orwell")
    static let book1 = Book(title: "1984", year: "2012", author: author)
    static let book2 = Book(title: "1999", year: "2012", author: author)
    static var previews: some View {
        ImageCell(url: book1.artworkUrl)
        ImageCell(url: book2.artworkUrl)
    }
}
#endif
