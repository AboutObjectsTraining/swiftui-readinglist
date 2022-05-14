// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct TextFieldCell: View {
    let title: String
    let isEditing: Bool
    @Binding var value: String
    @FocusState var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.brown.opacity(0.5))
                .font(.caption)
                .padding(.bottom, -4)
            TextField(title, text: $value)
                .conditionalTextFieldStyle(editing: isEditing)
                .focused($isFocused)
                .clearButton(text: $value, isFocused: isFocused)
        }
        .listRowBackground(Color.brown.opacity(0.1))
    }
    
    init(_ title: String, value: Binding<String>, editing: Bool) {
        self.title = title
        self.isEditing = editing
        _value = value
    }
}

extension TextField {
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

#if DEBUG
struct TextFieldCell_PreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Form {
                TextFieldCell("Name", value: .constant("Fred Smith"), editing: true)
                TextFieldCell("Name", value: .constant("Jane Jones"), editing: false)
            }
            Form {
                TextFieldCell("Name", value: .constant("Fred Smith"), editing: true)
                TextFieldCell("Name", value: .constant("Jane Jones"), editing: false)
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.fixed(width: 400, height: 200))
    }
}
#endif
