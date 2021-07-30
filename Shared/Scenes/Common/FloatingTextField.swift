//
//  FloatingTextField.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 7/31/21.
//

import SwiftUI


struct FloatingTextField: View {
    
    //MARK: - Public
    let textFieldHeight: CGFloat = 44
    let isSequre: Bool
    @Binding var text: String
    
    //MARK: - Private
    
    private let placeHolderText: String
    @State private var isEditing = false
    
    
    public init(placeHolder: String,
                isSequre: Bool = false,
                text: Binding<String>) {
        self._text = text
        self.placeHolderText = placeHolder
        self.isSequre = isSequre
    }
    
    var shouldPlaceHolderMove: Bool {
        isEditing || (text.count != 0)
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if !isSequre {
                TextField("", text: $text, onEditingChanged: { (edit) in
                    isEditing = edit
                })
                .modifier(Field(textFieldHeight: textFieldHeight))
                
            } else {
                SecureField("", text: $text) {
                    isEditing = true
                }
                .modifier(Field(textFieldHeight: textFieldHeight))
            }
            
            Text(placeHolderText)
                .foregroundColor(Color.mainCyan)
                .padding([.leading, .trailing], 5)
                .background(Color(UIColor.systemBackground))
                .padding(shouldPlaceHolderMove ?
                            EdgeInsets(top: 0, leading: 15, bottom: textFieldHeight, trailing: 0) :
                            EdgeInsets(top: 0, leading:15, bottom: 0, trailing: 0))
                .scaleEffect(shouldPlaceHolderMove ? 1.0 : 1.2)
                .animation(.easeInOut(duration: 0.2))
        }
    }
    
    struct Field: ViewModifier {
        let textFieldHeight: CGFloat
        
        func body(content: Content) -> some View {
            content
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.mainCyan, lineWidth: 1)
                            .frame(height: textFieldHeight))
                .foregroundColor(Color.mainCyan)
                .accentColor(Color.mainCyan)
                .animation(.easeInOut(duration: 0.2))
        }
    }
    
}

struct DemoFloatingTextField: View {
    @State var name: String = ""
    @State var email: String = ""
    
    var body: some View {
        VStack {
            FloatingTextField(placeHolder: "Name", text: $name)
            FloatingTextField(placeHolder: "Email", text: $email)
        }.padding()
    }
}

struct FloatingTextField_Previews: PreviewProvider {
    static var previews: some View {
        DemoFloatingTextField()
    }
}
