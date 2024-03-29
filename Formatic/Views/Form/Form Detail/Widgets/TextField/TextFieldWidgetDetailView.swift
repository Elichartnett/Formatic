//
//  TextFieldWidgetDetailView.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/19/22.
//

import SwiftUI

struct TextFieldWidgetDetailView: View {
    
    @ObservedObject var textFieldWidget: TextFieldWidget
    @State var text: String = Constants.emptyString
    @FocusState var isFocused: Bool
    
    var body: some View {
        
        VStack {
            TextField(Strings.textLabel, text: $text, axis: .vertical)
                .focused($isFocused)
                .onAppear {
                    text = textFieldWidget.text ?? Constants.emptyString
                }
                .onChange(of: text) { _ in
                    textFieldWidget.text = text
                }
                .padding()
                .background(Color.secondaryBackground.cornerRadius(10))
                .overlay {
                    Color.clear
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onTapGesture {
                            isFocused = true
                        }
                }
            
                Spacer()
            
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(textFieldWidget.title ?? Constants.emptyString)
        .background(Color.primaryBackground.ignoresSafeArea())
        .toolbar {
            FormaticToolbar()
        }
    }
}


struct TextFieldWidgetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TextFieldWidgetDetailView(textFieldWidget: dev.textFieldWidget)
        }
    }
}
