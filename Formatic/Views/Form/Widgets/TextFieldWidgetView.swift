//
//  TextFieldWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct TextFieldWidgetView: View {
    
    @ObservedObject var textFieldWidget: TextFieldWidget
    @Binding var locked: Bool
    @State var title: String = ""
    @State var text: String = ""
    
    var body: some View {
        
        HStack {
            
            InputBox(placeholder: "Title", text: $title)
                .titleFrameStyle()
                .onChange(of: title) { _ in
                    textFieldWidget.title = title
                }
                .disabled(locked)
            
            InputBox(placeholder: "text", text: $text)
                .onChange(of: text) { _ in
                    textFieldWidget.text = text
                }
        }
        .onAppear {
            title = textFieldWidget.title ?? ""
            text = textFieldWidget.text ?? ""
        }
    }
}

struct TextFieldWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWidgetView(textFieldWidget: dev.textFieldWidget, locked: .constant(false))
    }
}
