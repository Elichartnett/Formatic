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
    var range: ClosedRange<Double>?
    @State var isValid: Bool = true
    
    var body: some View {
        
        HStack {
            
            InputBox(placeholder: "Title", text: $title)
                .frame(width: 200)
            
            InputBox(placeholder: "text", text: $number)
                .onChange(of: number) { _ in
                    isValid = model.validNumber(number: number, range: range)
                    if isValid {
                        numberFieldWidget.number = number
                    }
                    else {
                        number.removeAll { character in
                            !character.isNumber && (character != "-" || character != ".")
                        }
                    }//negative doesnt show
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
    }
}
