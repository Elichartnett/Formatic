//
//  ConfigureTextFieldWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/3/22.
//
import SwiftUI
import FirebaseAnalytics

struct ConfigureTextFieldWidgetView: View {
    
    @EnvironmentObject var formModel: FormModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var title: String
    @FocusState var isFocused: Bool
    @State var section: Section
    @State var text: String = Constants.emptyString
    
    var body: some View {
        
        VStack {
            
            ZStack (alignment: .topLeading) {
                TextEditor(text: $text)
                    .widgetFrameStyle(isFocused: isFocused, height: .adaptive)
                    .focused($isFocused)
                
                if text.isEmpty {
                    Text(Strings.textLabel)
                        .onTapGesture {
                            isFocused = true
                        }
                        .foregroundColor(Color.customGray)
                        .padding(.top, 10)
                        .padding(.leading, 5)
                }
            }
            
            Button {
                let textFieldWidget = TextFieldWidget(title: title, position: section.numberOfWidgets(), text: text.isEmpty ? nil : text)
                withAnimation {
                    section.addToWidgets(textFieldWidget)
                }
                Analytics.logEvent(Constants.analyticsCreateTextFieldWidgetEvent, parameters: nil)
                dismiss()
            } label: {
                SubmitButton()
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
