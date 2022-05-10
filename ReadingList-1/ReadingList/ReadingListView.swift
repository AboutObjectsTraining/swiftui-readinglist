// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct ReadingListView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Text("This reading list doesn't contain any books.")
                    .font(.system(size: 24, weight: .medium).italic())
                    .foregroundColor(.secondary)
                    .padding(30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.tertiary)
            .navigationTitle("My Reading List")
        }
    }
}

struct ReadingListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ReadingListView()
            ReadingListView()
                .preferredColorScheme(.dark)
        }
    }
}
