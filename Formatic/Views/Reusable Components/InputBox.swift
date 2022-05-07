//
//  InputBox.swift
// Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

// Standard text field
struct InputBox: View {
    
    @FocusState var isFocused: Bool
    @State var placeholder: String
    @Binding var text: String
    @State var inputType: InputType = .text
    
    var body: some View {
        
        Group {
            switch inputType {
                
            case .text:
                TextField(placeholder, text: $text)
                
            case .password:
                SecureField(placeholder, text: $text)
            }
        }
        .foregroundColor(.primary)
        .padding(.leading)
        .frame(height: 40)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isFocused ? .blue : .secondary, lineWidth: 2)
        )
        .focused($isFocused)
    }
}

struct InputBox_Previews: PreviewProvider {
    static var previews: some View {
        InputBox(placeholder: "Placeholder...", text: .constant(""))
    }
}
