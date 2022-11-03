//
//  TextEditorWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct TextEditorWidgetView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var textEditorWidget: TextEditorWidget
    @Binding var locked: Bool
    @FocusState var isFocused: Bool
    @State var title: String
    @State var text: String
    
    init(textEditorWidget: TextEditorWidget, locked: Binding<Bool>) {
        self.textEditorWidget = textEditorWidget
        self._locked = locked
        self._title = State(initialValue: textEditorWidget.title ?? "")
        self._text = State(initialValue: textEditorWidget.text ?? "")
    }
    
    var body: some View {
        
        HStack {
            
            InputBox(placeholder: Strings.titleLabel, text: $title)
                .titleFrameStyle(locked: $locked)
                .onAppear {
                    title = textEditorWidget.title ?? ""
                    text = textEditorWidget.text ?? ""
                }
                .onChange(of: title) { _ in
                    textEditorWidget.title = title
                }
            
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
                    .scrollContentBackground(.hidden)
                    .background {
                        if colorScheme == .light {
                            Color.white.ignoresSafeArea()
                        }
                        else {
                            Color(uiColor: .systemGray6).ignoresSafeArea()
                        }
                    }
                if text.isEmpty {
                    Text(Strings.startTypingHereLabel)
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
