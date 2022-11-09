//
//  TextEditorWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct TextEditorWidgetView: View {
    
    @EnvironmentObject var formModel: FormModel
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
        
        let baseView = Group {
            InputBox(placeholder: Strings.titleLabel, text: $title)
                .titleFrameStyle(locked: $locked)
                .padding(.top, formModel.isPhone ? 6 : 0)
                .onAppear {
                    title = textEditorWidget.title ?? ""
                    text = textEditorWidget.text ?? ""
                }
                .onChange(of: title) { _ in
                    textEditorWidget.title = title
                }
            
            ZStack (alignment: .topLeading) {
                TextEditor(text: $text)
                    .WidgetFrameStyle(isFocused: isFocused, height: .adaptive)
                    .padding(.bottom, formModel.isPhone ? 6 : 0)
                    .focused($isFocused)
                    .onChange(of: text) { _ in
                        textEditorWidget.text = text
                    }
                    .scrollContentBackground(.hidden)
                if text.isEmpty {
                    Text(Strings.startTypingHereLabel)
                        .onTapGesture {
                            isFocused = true
                        }
                        .foregroundColor(Color(uiColor: UIColor.systemGray3))
                        .padding(.top, 10)
                        .padding(.leading, 5)
                }
            }
        }
            .alignmentGuide(.listRowSeparatorLeading, computeValue: { viewDimensions in
                return viewDimensions[.listRowSeparatorLeading]
            })
        
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
