//
//  SearchBar.swift
//  TravelApp
//
//  Created by Valeriy Jefimov on 8/17/21.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var searchText: String
    var isFocused: Bool
    var onCancel: (() -> Void)? = nil
    
    var body: some View {
        ZStack() {
            Capsule()
                .foregroundColor(.white)
                .shadow(radius: 10, y: 5)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(.mainCyan)
                    .frame(width: 23, height: 23)
                AutoFocusTextField(text: $searchText.animation(),
                                   placeholder: "Search For Places",
                                   isFocused: isFocused)
                    .accentColor(.mainCyan)
                
                if onCancel != nil && !searchText.isEmpty {
                    Button {
                        withAnimation(.easeInOut(duration: 0.1)) { onCancel?() }
                    } label: {
                        Text("Back")
                            .foregroundColor(.mainCyan)
                    }
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
            .padding()
            
        }
        .frame(height: 60)

    }
}

struct AutoFocusTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var isFocused: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: UIViewRepresentableContext<AutoFocusTextField>) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.delegate = context.coordinator
        return textField
    }

    func updateUIView(_ uiView: UITextField, context:
        UIViewRepresentableContext<AutoFocusTextField>) {
        uiView.text = text
        if isFocused {
            uiView.becomeFirstResponder()
        }
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: AutoFocusTextField

        init(_ autoFocusTextField: AutoFocusTextField) {
            self.parent = autoFocusTextField
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchText: .constant(""), isFocused: false)
    }
}
