//
//  NumberFieldWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct NumberFieldWidgetView: View {
    
    @EnvironmentObject var formModel: FormModel
    @ObservedObject var numberFieldWidget: NumberFieldWidget
    @Binding var locked: Bool
    @State var title: String
    @State var number: String
    @State var isValid: Bool = true
    var range: ClosedRange<Double>? = nil
    
    init(numberFieldWidget: NumberFieldWidget, locked: Binding<Bool>, range: ClosedRange<Double>? = nil) {
        self.numberFieldWidget = numberFieldWidget
        self._locked = locked
        self.title = numberFieldWidget.title ?? ""
        self.number = numberFieldWidget.number ?? ""
        self.range = range
        self.isValid = isValid
    }
    
    var body: some View {
        
        let baseView = Group {
            InputBox(placeholder: Strings.titleLabel, text: $title)
                .titleFrameStyle(locked: $locked)
                .onChange(of: title) { _ in
                    numberFieldWidget.title = title
                }
            
            InputBox(placeholder: Strings.numberLabel, text: $number)
                .onChange(of: number) { _ in
                    isValid = formModel.numberIsValid(number: number, range: range)
                    if isValid {
                        numberFieldWidget.number = number
                    }
                    else {
                        number.removeAll { character in
                            !character.isNumber && character != "-" && character != "."
                        }
                        
                        var decimalUsed = false
                        for (index, character) in number.enumerated() {
                            if character == "-" && index != 0 {
                                number.remove(at: number.index(number.startIndex, offsetBy: index))
                            }
                            else if character == "." {
                                if !decimalUsed {
                                    decimalUsed = true
                                }
                                else {
                                    number.remove(at: number.index(number.startIndex, offsetBy: index))
                                }
                            }
                        }
                    }
                }
        }
        
        if formModel.isPhone {
            VStack(alignment: .leading, spacing: FormModel.spacingConstant) {
                baseView
            }
        }
        else {
            HStack(spacing: FormModel.spacingConstant) {
                baseView
            }
        }
    }
}

struct NumberFieldWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        NumberFieldWidgetView(numberFieldWidget: dev.numberFieldWidget, locked: .constant(false))
            .environmentObject(FormModel())
    }
}