//
//  InputBox.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct InputBox: View {
    
    @EnvironmentObject var formModel: FormModel
    @FocusState var isFocused: Bool
    
    @State var placeholder: String
    @Binding var text: String
    @State var inputType: InputType
    @Binding var isValid: Bool
    var validRange: ClosedRange<Double>?
    var axis: Axis
    
    init(placeholder: String, text: Binding<String>, inputType: InputType = .text, isValid: Binding<Bool> = .constant(true), validRange: ClosedRange<Double>? = nil, axis: Axis = .horizontal) {
        self.placeholder = placeholder
        self._text = text
        self.inputType = inputType
        self._isValid = isValid
        self.validRange = validRange
        self.axis = axis
    }
    
    var body: some View {
        
        Group {
            switch inputType {
                
            case .text:
                TextField(placeholder, text: $text, axis: axis)

            case .number:
                let isNegative = text.first == "-"
                TextField(placeholder, text: $text)
                    .onAppear(perform: validateNumber)
                    .onChange(of: text) { _ in
                        withAnimation {
                            validateNumber()
                        }
                    }
                    .keyboardType(.decimalPad)
                    .toolbar {
                        if inputType == .number && isFocused {
                            ToolbarItem(placement: .keyboard) {
                                Button {
                                    if isNegative {
                                        text = String(text.trimmingPrefix("-"))
                                    }
                                    else {
                                        text = "-\(text)"
                                    }
                                } label: {
                                    Image(systemName: "plusminus")
                                        .customIcon()
                                }
                            }
                        }
                    }
                
            case .password:
                SecureField(placeholder, text: $text)
            }
        }
        .foregroundColor(isValid ? .primary : .red)
        .padding(.leading)
        .WidgetFrameStyle(isFocused: isFocused, height: axis == .vertical ? .adaptive : .regular)
        .focused($isFocused)
    }
    
    func validateNumber() {
        let isNegative = text.first == "-"

        if text.isEmpty {
            isValid = true
        }
        else if text == "-" || text == "-." {
            isValid = false
        }
        else {
            if let decimalIndex = text.firstIndex(of: "."), let firstNumberIndex = text.firstIndex(where: { character in
                character.isNumber == true
            }) {
                text = String(text.trimmingPrefix("-"))
                if decimalIndex < firstNumberIndex {
                    if decimalIndex == text.startIndex {
                        text = "0\(text)"
                    }
                    else {
                        text.insert("0", at: text.index(before: decimalIndex))
                    }
                }
                if isNegative {
                    text = "-\(text)"
                }
            }
            isValid = text.isValidNumber(range: validRange)
        }
    }
}

struct InputBox_Previews: PreviewProvider {
    static var previews: some View {
        InputBox(placeholder: "Placeholder...", text: .constant(""), inputType: .number)
    }
}
