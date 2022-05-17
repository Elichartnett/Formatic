//
//  InputBox.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

// Standard text field
struct InputBox: View {
    
    @EnvironmentObject var model: FormModel
    @FocusState var isFocused: Bool
    @State var placeholder: String
    @Binding var text: String
    @State var inputType: InputType
    @Binding var isValid: Bool
    var numberRange: ClosedRange<Double>?
    
    init(placeholder: String, text: Binding<String>, inputType: InputType = .text, isValid: Binding<Bool> = .constant(true), numberRange: ClosedRange<Double>? = nil) {
        self.placeholder = placeholder
        self._text = text
        self.inputType = inputType
        self._isValid = isValid
        self.numberRange = numberRange
    }
    
    var body: some View {
        
        Group {
            switch inputType {
                
            case .text:
                TextField(placeholder, text: $text)
                
            case .number:
                TextField(placeholder, text: $text)
                    .foregroundColor(isValid ? .primary : .red)
                    .onChange(of: text) { _ in
                        withAnimation {
                            if text.isEmpty {
                                isValid = true
                            }
                            else {
                                isValid = model.validNumber(number: text, range: numberRange)
                            }
                        }
                    }
                
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