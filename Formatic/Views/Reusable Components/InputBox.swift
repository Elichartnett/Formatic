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
    var allowNegative: Bool
    var allowZero: Bool
    var sliderStep: Bool
    
    init(placeholder: String, text: Binding<String>, inputType: InputType = .text, isValid: Binding<Bool> = .constant(true), validRange: ClosedRange<Double>? = nil, axis: Axis = .horizontal, showNegative: Bool = true, allowZero: Bool = true, sliderStep: Bool = false) {
        self.placeholder = placeholder
        self._text = text
        self.inputType = inputType
        self._isValid = isValid
        self.validRange = validRange
        self.axis = axis
        self.allowNegative = showNegative
        self.allowZero = allowZero
        self.sliderStep = sliderStep
    }
    
    var body: some View {
        
        Group {
            switch inputType {
                
            case .text:
                TextField(placeholder, text: $text, axis: axis)

            case .number:
                TextField(placeholder, text: $text)
                    .onAppear(perform: validateNumber)
                    .onChange(of: text) { _ in
                        withAnimation {
                            validateNumber()
                        }
                    }
                    .keyboardType(.decimalPad)
                    .toolbar {
                        if allowNegative {
                            if inputType == .number && isFocused {
                                ToolbarItem(placement: .keyboard) {
                                    Button {
                                        if let textDouble = Double(text) {
                                            text = String(textDouble * -1)
                                        }
                                    } label: {
                                        Image(systemName: Constants.plusMinusIconName)
                                            .customIcon()
                                    }
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
        .widgetFrameStyle(isFocused: isFocused, height: axis == .vertical ? .adaptive : .regular)
        .focused($isFocused)
    }
    
    func validateNumber() {
        let isNegative = text.first == "-"

        if text.isEmpty {
            isValid = true
        }
        else if text == "0" && !allowZero || text == "0." && !allowZero {
            isValid = false
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
            if !sliderStep {
                isValid = text.isValidNumber(range: validRange)
            }
            else {
                if let stepDouble = Double(text), let lowerBound = validRange?.lowerBound, let upperBound = validRange?.upperBound {
                    isValid = stepDouble <= (upperBound.magnitude - lowerBound.magnitude).magnitude
                }
            }
        }
        if isNegative && !allowNegative {
            isValid = false
        }
    }
}

struct InputBox_Previews: PreviewProvider {
    static var previews: some View {
        InputBox(placeholder: "Placeholder...", text: .constant(Constants.emptyString), inputType: .number)
    }
}
