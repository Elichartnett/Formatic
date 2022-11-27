//
//  CheckboxWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/7/22.
//

import SwiftUI

struct CheckboxWidgetView: View {
    
    @ObservedObject var checkbox: CheckboxWidget
    @State var description: String = ""
    @FocusState var isFocused: Bool
    
    var body: some View {
        
        HStack {
            
            Button {
                withAnimation {
                    checkbox.checked.toggle()
                }
            } label: {
                if checkbox.checked {
                    Image(systemName: Constants.filledCheckmarkIconName)
                }
                else {
                    Image(systemName: Constants.squareIconName)
                }
            }
            .buttonStyle(.plain)
            .foregroundColor(.secondary)
            
            TextField(Strings.descriptionLabel, text: $description)
                .focused($isFocused)
                .onAppear {
                    description = checkbox.title ?? ""
                }
                .onChange(of: description) { _ in
                    checkbox.title = description
                }
        }
    }
}

struct CheckboxWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        CheckboxWidgetView(checkbox: dev.checkboxWidget)
    }
}
