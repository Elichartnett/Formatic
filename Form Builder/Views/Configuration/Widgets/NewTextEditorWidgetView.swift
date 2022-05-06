//
//  NewTextEditorView.swift
//  Form Builder
//
//  Created by Eli Hartnett on 5/3/22.
//

import SwiftUI

// In new widget sheet to configure new TextEditorWidget
struct NewTextEditorWidgetView: View {
        
    @Binding var newWidgetType: WidgetType?
    @Binding var title: String
    @FocusState var isFocused: Bool
    @State var section: Section
    @State var text: String = ""

    var body: some View {
        
        VStack {
            
            ZStack (alignment: .topLeading) {
                TextEditor(text: $text)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isFocused ? .blue : .secondary, lineWidth: 2)
                    )
                .focused($isFocused)
                
                if text.isEmpty {
                    Text("Start type here...")
                        .foregroundColor(Color(uiColor: UIColor.systemGray3))
                        .padding(.top, 10)
                        .padding(.leading, 5)
                }
            }
            
            Button {
                let textEditorWidget = TextEditorWidget(title: title, position: section.widgetsArray.count-1, text: text)
                section.addToWidgets(textEditorWidget)
                DataController.saveMOC()
                newWidgetType = nil
            } label: {
                SubmitButton(isValid: .constant(true))
            }
            .padding(.bottom)
        }
    }
}

struct NewTextEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NewTextEditorWidgetView(newWidgetType: .constant(.textEditorWidget), title: .constant(dev.textEditorWidget.title!), section: dev.section)
    }
}
