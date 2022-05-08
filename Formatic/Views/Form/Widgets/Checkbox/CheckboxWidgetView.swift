//
//  CheckboxWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/7/22.
//

import SwiftUI

struct CheckboxWidgetView: View {
    
    @ObservedObject var checkbox: CheckboxWidget
    
    var body: some View {
        
        Button {
            withAnimation {
                checkbox.checked.toggle()
                DataController.saveMOC()
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
    }
}

struct CheckboxWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        CheckboxWidgetView(checkbox: dev.checkboxWidget)
    }
}
