//
//  TextFieldWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct TextFieldWidgetView: View {
    
    @EnvironmentObject var formModel: FormModel
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var textFieldWidget: TextFieldWidget
    @Binding var locked: Bool
    @FocusState var isFocused: Bool
    @State var title: String
    @State var text: String
    
    init(textFieldWidget: TextFieldWidget, locked: Binding<Bool>) {
        self.textFieldWidget = textFieldWidget
        self._locked = locked
        self._title = State(initialValue: textFieldWidget.title ?? "")
        self._text = State(initialValue: textFieldWidget.text ?? "")
    }
    
    var body: some View {
        
        let baseView = Group {
            InputBox(placeholder: Strings.titleLabel, text: $title)
                .titleFrameStyle(locked: $locked)
                .padding(.top, 6)
                .onAppear {
                    title = textFieldWidget.title ?? ""
                    text = textFieldWidget.text ?? ""
                }
                .onChange(of: title) { _ in
                    textFieldWidget.title = title
                }
            
            ZStack (alignment: .topLeading) {
                TextEditor(text: $text)
                    .padding(.top)
                    .padding(.leading)
                    .WidgetFrameStyle(isFocused: isFocused, height: .adaptive)
                    .padding(.bottom, 6)
                    .padding(.top, !formModel.isPhone ? 6 : 0)
                    .focused($isFocused)
                    .onChange(of: text) { _ in
                        textFieldWidget.text = text
                    }
                    .scrollContentBackground(.hidden)
                if text.isEmpty {
                    Text(Strings.textLabel)
                        .onTapGesture {
                            isFocused = true
                        }
                        .foregroundColor(Color(uiColor: UIColor.systemGray3))
                        .padding(.top)
                        .padding(.leading)
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
