// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

extension RealTextField {
    
    /// A child of the `RealTextFieldCell` instance. Serves as the text field's delegate.
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: RealTextField
        
        init(parent: RealTextField) {
            self.parent = parent
        }
        
        /// Updates the parent View's `text` property whenever the text field's value changes.
        func textField(_ textField: UITextField,
                       shouldChangeCharactersIn range: NSRange,
                       replacementString string: String) -> Bool {
            
            guard let text = textField.text as? NSString else { return true }
            parent.text = text.replacingCharacters(in: range, with: string)
            return true
        }
        
        func textFieldShouldClear(_ textField: UITextField) -> Bool {
            parent.text = ""
            return true
        }
    }
}

struct RealTextField: UIViewRepresentable {
    
    let placeholder: String
    @Binding var text: String
    
    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        _text = text
    }
    
    private let textField = UITextField()
    
    /// Creates and configures a wrapped UITextField instance.
    /// - Parameter context: Wrapper for the View's environment and animation state
    /// - Returns: A wrapped instance of UITextField
    func makeUIView(context: Context) -> UITextField {
        textField.frame.size.height = 40
        textField.placeholder = placeholder
        
        // The coordinator implements one or more UITextFieldDelegate methods.
        textField.delegate = context.coordinator
        
        return textField
    }
    
    /// Ensures that the wrapped text field is in sync with current state if the struct gets recreated.
    /// - Parameters:
    ///   - uiView: The wrapped text field
    ///   - context: Wrapper for the View's environment and animation state
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.placeholder = placeholder
    }
    
    /// Serves as a bridge between this struct and it's wrapped UITextField instance.
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}

/// Modifiers
extension RealTextField {
    
    func clearButton(mode: UITextField.ViewMode) -> RealTextField {
        textField.clearButtonMode = mode
        return self
    }
    
    func autofocused() -> RealTextField {
        textField.becomeFirstResponder()
        return self
    }
}


#if DEBUG
struct RealTextFieldDemoView: View {
    @State var firstName = ""
    @State var lastName = ""
    
    var body: some View {
        Form {
            HStack {
                Text(firstName)
                Text(lastName)
            }
            RealTextField("First name", text: $firstName)
                .clearButton(mode: .whileEditing)
                .autofocused()
            RealTextField("Last name", text: $lastName)
                .clearButton(mode: .whileEditing)
        }
        .padding()
    }
}

struct RealTextFieldCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RealTextFieldDemoView()
        }
        .previewLayout(
            .fixed(width: 400, height: 200)
        )
    }
}
#endif
