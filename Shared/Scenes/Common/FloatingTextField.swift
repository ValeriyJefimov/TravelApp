//
//  FloatingTextField.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 7/31/21.
//

import SwiftUI
protocol FloatingField {
    var text: String { get set }
    var textFieldHeight: CGFloat { get set }
    var placeHolderText: String { get set }
    var isEditing: Bool  { get set }
}

extension FloatingField {
    var shouldPlaceHolderMove: Bool {
        isEditing || (text.count != 0)
    }
}

fileprivate struct Field: ViewModifier {
    let textFieldHeight: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.mainCyan, lineWidth: 1)
                        .frame(height: textFieldHeight))
            .foregroundColor(Color.mainCyan)
            .accentColor(Color.mainCyan)
    }
}

fileprivate struct FloatingPlaceholder: ViewModifier {
    let textFieldHeight: CGFloat
    let shouldPlaceHolderMove: Bool
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.mainCyan)
            .padding([.leading, .trailing], 5)
            .background(Color(UIColor.systemBackground))
            .padding(shouldPlaceHolderMove ?
                        EdgeInsets(top: 0, leading: 15, bottom: textFieldHeight, trailing: 0) :
                        EdgeInsets(top: 0, leading:15, bottom: 0, trailing: 0))
            .scaleEffect(shouldPlaceHolderMove ? 1.0 : 1.2)
    }
}

struct FloatingTextField: View, FloatingField {

    //MARK: - Public
    var textFieldHeight: CGFloat = 44
    var placeHolderText: String
    @Binding var text: String
    @State var isEditing = false

    public init(placeHolder: String,
                text: Binding<String>) {
        self._text = text
        self.placeHolderText = placeHolder
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            TextField("", text: $text, onEditingChanged: { (edit) in
                isEditing = edit
            })
            .modifier(Field(textFieldHeight: textFieldHeight))
            
            Text(placeHolderText)
                .modifier(FloatingPlaceholder(textFieldHeight: textFieldHeight,
                                              shouldPlaceHolderMove: shouldPlaceHolderMove))
        }
    }
}

struct FloatingSecureField: View, FloatingField {

    //MARK: - Public
    var textFieldHeight: CGFloat = 44
    var placeHolderText: String
    @Binding var text: String
    @State var isSecureVisible = false
    @State var isEditing = false

    public init(placeHolder: String,
                text: Binding<String>) {
        self._text = text
        self.placeHolderText = placeHolder
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                if isSecureVisible {
                    TextField("", text: $text, onEditingChanged: { (edit) in
                        isEditing = edit
                    }, onCommit: {
                        isEditing = false
                    })
                    .onTapGesture {
                        isEditing = true
                    }
                } else {
                    SecureField("", text: $text) {
                        isEditing = false
                    }
                    .onTapGesture {
                        isEditing = true
                    }
                }
                
                Button(action: {
                    isSecureVisible = !isSecureVisible
                }, label: {
                    isSecureVisible ? Image(systemName: "eye") : Image(systemName: "eye.slash")
                })
            }
          
            .modifier(Field(textFieldHeight: textFieldHeight))
            
            Text(placeHolderText)
                .modifier(FloatingPlaceholder(textFieldHeight: textFieldHeight,
                                              shouldPlaceHolderMove: shouldPlaceHolderMove))
               
        }
    }
}

struct DemoFloatingTextField: View {
    @State var name: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack {
            FloatingTextField(placeHolder: "Name", text: $name)
            FloatingSecureField(placeHolder: "Password", text: $password)
        }.padding()
    }
}

struct FloatingTextField_Previews: PreviewProvider {
    static var previews: some View {
        DemoFloatingTextField()
    }
}
