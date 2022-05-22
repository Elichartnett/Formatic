//
//  NewNumberFieldView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/3/22.
//

import SwiftUI

// In new widget sheet to configure new NumberFieldWidget
struct NewNumberFieldWidgetView: View {
    
    @EnvironmentObject var formModel: FormModel
    
    @Binding var newWidgetType: WidgetType?
    @Binding var title: String
    @State var section: Section
    @State var number: String = ""
    var range: ClosedRange<Double>?
    @State var isValid: Bool = true
    
    var body: some View {
        VStack {
            InputBox(placeholder: "number", text: $number, inputType: .number, isValid: $isValid)
                .onChange(of: number) { _ in
                    withAnimation {
                        if number.isEmpty {
                            isValid = true
                        }
                        else {
                            isValid = formModel.validNumber(number: number, range: range)
                        }
                    }
                }
            
            Button {
                let numberFieldWidget = NumberFieldWidget(title: title, position: formModel.numberOfWidgetsInSection(section: section), number: number)
                withAnimation {
                    section.addToWidgets(numberFieldWidget)
                    DataController.saveMOC()
                }
                newWidgetType = nil
            } label: {
                SubmitButton(isValid: $isValid)
            }
            .disabled(!isValid)
        }
    }
}

struct NewNumberFieldView_Previews: PreviewProvider {
    static var previews: some View {
        NewNumberFieldWidgetView(newWidgetType: .constant(.numberFieldWidget), title: .constant(dev.numberFieldWidget.title!), section: dev.section)
        
    }
}
