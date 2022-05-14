// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct BookCell: View {
    @Environment(\.editMode) private var editMode
    @ObservedObject var viewModel: BookCellViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            ThumbnailImage(url: viewModel.book.artworkUrl)
                .layoutPriority(1)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(viewModel.book.title)")
                    .font(.headline)
                    .foregroundColor(Color.green)
                    .padding(.vertical, 3)
                Text("\(viewModel.book.year)  \(viewModel.book.author.fullName)")
                    .font(.subheadline)
                    .padding(.bottom, 10)
            }
            .layoutPriority(2)
            
            Spacer()
            
            if editMode?.wrappedValue.isEditing == false {
                HStack {
                    Spacer()
                    ProgressView("Loading...", value: viewModel.book.percentComplete)
                        .progressViewStyle(CustomCircularProgressViewStyle())
                    NavigationLink {
                        EditBookView(viewModel: viewModel.makeEditBookViewModel())
                    } label: { }
                }
                .frame(maxWidth: 60)
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

struct CustomCircularProgressViewStyle: ProgressViewStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            let percentComplete = configuration.percentComplete
            let strokeStyle = StrokeStyle(lineWidth: 7)
            let color = configuration.color
            
            if (percentComplete < 1) {
                Circle()
                    .trim(from: 0.0, to: CGFloat(percentComplete))
                    .stroke(style: strokeStyle)
                    .rotationEffect(.degrees(-90))
                    .frame(width: 40)
                    .background(
                        Circle()
                            .stroke(color.opacity(0.3), style: strokeStyle)
                    )
                
                Text("\(Int(percentComplete * 100))%")
                    .font(.caption2)
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .imageScale(.large)
                    .font(.system(size: 32).weight(.medium))
                    .padding(.horizontal, -6)
            }
        }
        .foregroundColor(configuration.color)
    }
}

extension ProgressViewStyleConfiguration {
    var percentComplete: Double {
        fractionCompleted ?? 0
    }
    
    var color: Color {
        percentComplete < 0.1 ? .secondary :
        percentComplete < 0.7 ? .orange : .green
    }
}
