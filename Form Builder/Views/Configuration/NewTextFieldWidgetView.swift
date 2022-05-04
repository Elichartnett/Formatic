//
//  NewTextFieldView.swift
//  Form Builder
//
//  Created by Eli Hartnett on 5/3/22.
//

import SwiftUI

// In new widget sheet to configure new TextFieldWidget
struct NewTextFieldWidgetView: View {
    
    @Binding var newWidgetType: WidgetType?
    @Binding var title: String
    @State var section: Section
    @State var text: String = ""
    
    var body: some View {
        VStack {
            InputBox(placeholder: "text", text: $text)
            
            Button {
                let textFieldWidget = TextFieldWidget(title: title, position: Int16(section.widgetsArray.count), text: text)
                section.addToWidgets(textFieldWidget)
                DataController.saveMOC()
                newWidgetType = nil
                print("Create text field in \(section.title ?? "no title")")
            } label: {
                SubmitButton(isValid: .constant(true))
            }
        }
    }
}

struct NewTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        NewTextFieldWidgetView(newWidgetType: .constant(.textFieldWidget), title: .constant(dev.textFieldWidget.title!), section: dev.section)
    }
}
