//
//  ConfigureTextEditorView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/3/22.
//

import SwiftUI

// In new widget sheet to configure new TextEditorWidget
struct ConfigureTextEditorWidgetView: View {
    
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
                let textEditorWidget = TextEditorWidget(title: title, position: formModel.numberOfWidgetsInSection(section: section), text: text)
                withAnimation {
                    section.addToWidgets(textEditorWidget)
                }
                dismiss()
            } label: {
                SubmitButton(isValid: .constant(true))
            }
            .padding(.bottom)
        }
    }
}

struct ConfigureTextEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureTextEditorWidgetView(title: .constant(dev.textEditorWidget.title!), section: dev.section)
    }
}
