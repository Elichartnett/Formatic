//
//  CheckboxWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/7/22.
//

import SwiftUI

struct CheckboxWidgetView: View {
    
    @Binding var checked: Bool
    
    var body: some View {
        
        Button {
            withAnimation {
                checked.toggle()
            }
        } label: {
            if checked {
                Image(systemName: "checkmark.square.fill")
            }
            else {
                Image(systemName: "square")
            }
        }
        .foregroundColor(.black)
    }
}

struct CheckboxWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        CheckboxWidgetView(checked: .constant(false))
    }
}
