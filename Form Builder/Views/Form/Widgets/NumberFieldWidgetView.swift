//
//  NumberFieldWidgetView.swift
//  Form Builder
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct NumberFieldWidgetView: View {
    
    @EnvironmentObject var model: FormModel
    @ObservedObject var numberFieldWidget: NumberFieldWidget
    @State var title: String = ""
    @State var number: String = ""
    var range: ClosedRange<Double>? = nil
    @State var isValid: Bool = true
    
    var body: some View {
        
        HStack {
            
            InputBox(placeholder: "Title", text: $title)
                .modifier(InputBoxTitle())
                .onChange(of: title) { _ in
                    numberFieldWidget.title = title
            }
            
            InputBox(placeholder: "text", text: $number)
                .onChange(of: number) { _ in
                    isValid = model.validNumber(number: number, range: range)
                    if isValid {
                        numberFieldWidget.number = number
                    }
                    else {
                        number.removeAll { character in
                            !character.isNumber && character != "-" && character != "."
                        }
                    }
                }
            
        }
        .onAppear {
            title = numberFieldWidget.title ?? ""
            number = numberFieldWidget.number ?? ""
        }
        
    }
}

struct NumberFieldWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        NumberFieldWidgetView(numberFieldWidget: dev.numberFieldWidget)
            .environmentObject(FormModel())
    }
}
