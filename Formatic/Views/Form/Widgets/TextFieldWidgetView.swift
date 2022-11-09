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
    @State var title: String
    @State var text: String
    
    init(textFieldWidget: TextFieldWidget, locked: Binding<Bool>) {
        self.textFieldWidget = textFieldWidget
        self._locked = locked
        self.title = textFieldWidget.title ?? ""
        self.text = textFieldWidget.text ?? ""
    }
    
    var body: some View {
        
        let baseView = Group {
            InputBox(placeholder: Strings.titleLabel, text: $title)
                .titleFrameStyle(locked: $locked)
                .onChange(of: title) { _ in
                    textFieldWidget.title = title
                }
                .disabled(locked)
            
            InputBox(placeholder: Strings.textLabel, text: $text)
                .onChange(of: text) { _ in
                    textFieldWidget.text = text
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

struct TextFieldWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWidgetView(textFieldWidget: dev.textFieldWidget, locked: .constant(false))
            .environmentObject(FormModel())
    }
}
