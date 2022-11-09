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
    @FocusState var isFocused: Bool
    @State var section: Section
    @State var text: String = ""
    
    var body: some View {
        
        VStack {
            
            ZStack (alignment: .topLeading) {
                TextEditor(text: $text)
                    .WidgetFrameStyle(isFocused: isFocused, height: .adaptive)
                    .focused($isFocused)
                
                if text.isEmpty {
                    Text(Strings.textLabel)
                        .onTapGesture {
                            isFocused = true
                        }
                        .foregroundColor(Color(uiColor: UIColor.systemGray3))
                        .padding(.top, 10)
                        .padding(.leading, 5)
                }
            }
            
            Button {
                let textFieldWidget = TextFieldWidget(title: title, position: formModel.numberOfWidgetsInSection(section: section), text: text)
                withAnimation {
                    section.addToWidgets(textFieldWidget)
                }
                dismiss()
            } label: {
                SubmitButton(isValid: .constant(true))
            }
            .padding(.bottom)
        }
    }
}

struct ConfigureTextFieldWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureTextFieldWidgetView(title: .constant(dev.textFieldWidget.title!), section: dev.section)
    }
}
