//
//  ConfigureTextFieldWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/3/22.
//

import SwiftUI

// In new widget sheet to configure new TextFieldWidget
struct ConfigureTextFieldWidgetView: View {
    
    @EnvironmentObject var formModel: FormModel
    @Environment(\.dismiss) var dismiss
    @Binding var title: String
    @State var section: Section
    @State var text: String = ""
    
    var body: some View {
        
        VStack {
            
            InputBox(placeholder: "text", text: $text)
            
            Button {
                let textFieldWidget = TextFieldWidget(title: title, position: formModel.numberOfWidgetsInSection(section: section), text: text)
                withAnimation {
                    section.addToWidgets(textFieldWidget)
                }
                dismiss()
            } label: {
                SubmitButton(isValid: .constant(true))
            }
        }
    }
}

struct ConfigureTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureTextFieldWidgetView(title: .constant(dev.textFieldWidget.title!), section: dev.section)
    }
}
