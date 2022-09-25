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
                    DataControllerModel.saveMOC()
                }
            } label: {
                if checkbox.checked {
                    Image(systemName: "checkmark.square.fill")
                }
                else {
                    Image(systemName: "square")
                }
            }
            .buttonStyle(.plain)
            .foregroundColor(.black)
            
            TextField("description", text: $description)
                .focused($isFocused)
                .onAppear {
                    description = checkbox.title ?? ""
                }
                .onChange(of: isFocused) { newValue in
                    DataControllerModel.saveMOC()
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
