//
//  TextFieldWidgetView.swift
//  Form Builder
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct TextFieldWidgetView: View {
    
    @ObservedObject var textFieldWidget: TextFieldWidget
    @State var title: String = ""
    @State var text: String = ""
    
    var body: some View {
        
        HStack {
            
            InputBox(placeholder: "Title", text: $title)
                .modifier(InputBoxTitle())
                .onChange(of: title) { _ in
                    textFieldWidget.title = title
            }
            
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
        TextFieldWidgetView(textFieldWidget: dev.textFieldWidget)
    }
}