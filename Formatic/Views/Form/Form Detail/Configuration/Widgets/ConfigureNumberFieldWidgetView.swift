//
//  ConfigureNumberFieldView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/3/22.
//
import SwiftUI
import FirebaseAnalytics

struct ConfigureNumberFieldWidgetView: View {
    
    @EnvironmentObject var formModel: FormModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var title: String
    @State var section: Section
    @State var number: String = ""
    var range: ClosedRange<Double>?
    @State var isValid: Bool = true
    
    var body: some View {
        VStack {
            InputBox(placeholder: Strings.numberLabel, text: $number, inputType: .number, isValid: $isValid)
                .onChange(of: number) { _ in
                    withAnimation {
                        if number.isEmpty {
                            isValid = true
                        }
                        else {
                            isValid = number.isValidNumber(range: range)
                        }
                    }
                }
            
            Button {
                let numberFieldWidget = NumberFieldWidget(title: title, position: section.numberOfWidgets(), number: number)
                withAnimation {
                    section.addToWidgets(numberFieldWidget)
                }
                Analytics.logEvent(Constants.analyticsCreateNumberFieldWidgetEvent, parameters: nil)
                dismiss()
            } label: {
                SubmitButton()
            }
            .disabled(!isValid)
        }
    }
}

struct ConfigureNumberFieldView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureNumberFieldWidgetView(title: .constant(dev.numberFieldWidget.title!), section: dev.section)
        
    }
}
