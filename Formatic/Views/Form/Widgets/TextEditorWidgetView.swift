//
//  TextEditorWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct TextEditorWidgetView: View {
    
    @ObservedObject var textEditorWidget: TextEditorWidget
    @Binding var locked: Bool
    @FocusState var isFocused: Bool
    @State var title: String = ""
    @State var text: String = ""
    
    var body: some View {
        
        HStack {
            
            InputBox(placeholder: "Title", text: $title)
                .titleFrameStyle()
                .onAppear {
                    title = textEditorWidget.title ?? ""
                    text = textEditorWidget.text ?? ""
                }
                .onChange(of: title) { _ in
                    textEditorWidget.title = title
                }
                .disabled(locked)
            
            ZStack (alignment: .topLeading) {
                TextEditor(text: $text)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isFocused ? .blue : .secondary, lineWidth: 2)
                    )
                    .frame(height: 200)
                    .focused($isFocused)
                    .onChange(of: text) { _ in
                        textEditorWidget.text = text
                    }
                
                if text.isEmpty {
                    Text("Start typing here...")
                        .foregroundColor(Color(uiColor: UIColor.systemGray3))
                        .padding(.top, 10)
                        .padding(.leading, 5)
                }
            }
        }
    }
}

struct TextEditorWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorWidgetView(textEditorWidget: dev.textEditorWidget, locked: .constant(false))
    }
}
