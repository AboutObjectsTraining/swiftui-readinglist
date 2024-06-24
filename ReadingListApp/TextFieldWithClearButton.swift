// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct TextFieldWithClearButton: View {
    let placeholder: String
    @Binding var text: String
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        TextField(placeholder, text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .foregroundColor(.primary)
            .focused($isTextFieldFocused)
            .clearButton(text: $text, isFocused: isTextFieldFocused)
    }
}

extension View {
    func clearButton(text: Binding<String>, isFocused: Bool) -> some View {
        modifier(ClearButton(text: text, isFocused: isFocused))
    }
}

struct ClearButton: ViewModifier {
    @Binding var text: String
    let isFocused: Bool
    
    public func body(content: Content) -> some View {
        return HStack {
            
            content
            
            if isFocused, !text.isEmpty {
                Button(
                    action: { self.text = "" },
                    label: {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.gray)
                    }
                )
                .padding(.trailing, 4)
            }
        }
    }
}

#if DEBUG
struct TextFieldWithClearButton_Test: View {
    @State var first = "Fred"
    @State var last = ""
    @FocusState var isFocused: Bool
    
    var body: some View {
        Form {
            Text(first + " ") + Text(last)
            TextFieldWithClearButton(placeholder: "First Name", text: $first)
                .listRowSeparator(.hidden)
            TextFieldWithClearButton(placeholder: "Last Name", text: $last)
                .listRowSeparator(.hidden)
                .padding(.bottom)
        }
    }
}

struct TextFieldWithClearButton_PreviewProvider_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            TextFieldWithClearButton_Test()
        }
    }
}
#endif
