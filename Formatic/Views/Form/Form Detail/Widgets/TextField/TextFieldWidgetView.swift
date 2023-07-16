//
//  TextFieldWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct TextFieldWidgetView: View {
    
    @EnvironmentObject var formModel: FormModel
    
    @ObservedObject var textFieldWidget: TextFieldWidget
    @Binding var locked: Bool
    @FocusState var isFocused: Bool
    @State var title: String
    
    init(textFieldWidget: TextFieldWidget, locked: Binding<Bool>) {
        self.textFieldWidget = textFieldWidget
        self._locked = locked
        self._title = State(initialValue: textFieldWidget.title ?? Constants.emptyString)
    }
    
    var body: some View {
        
        let baseView = Group {
            InputBox(placeholder: Strings.titleLabel, text: $title)
                .titleFrameStyle(locked: $locked)
                .onAppear {
                    title = textFieldWidget.title ?? Constants.emptyString
                }
                .onChange(of: title) { _ in
                    textFieldWidget.title = title
                }
            
            NavigationLink {
                TextFieldWidgetDetailView(textFieldWidget: textFieldWidget)
            } label: {
                Text(textFieldWidget.text ?? Strings.textLabel)
                    .foregroundColor(textFieldWidget.text == nil ? .customGray : .primary)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .widgetFrameStyle(height: .adaptive)
            }
        }
        
        if formModel.isPhone {
            VStack(alignment: .leading, spacing: Constants.stackSpacingConstant) {
                baseView
            }
        }
        else {
            
            HStack(spacing: Constants.stackSpacingConstant) {
                baseView
            }
        }
    }
}

struct TextFieldWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWidgetView(textFieldWidget: dev.textFieldWidget, locked: .constant(false))
    }
}
