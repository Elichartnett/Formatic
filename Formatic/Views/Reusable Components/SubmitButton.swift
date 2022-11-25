//
//  SubmitButton.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

// Standard submit button label
struct SubmitButton: View {
    
    let buttonTitle: String = Strings.submitLabel
    
    var body: some View {
        
        Text(buttonTitle)
            .font(.title)
            .foregroundColor(.primary)
            .padding()
            .background {
                Rectangle()
                    .cornerRadius(10)
            }
    }
}

struct SubmitButton_Previews: PreviewProvider {
    static var previews: some View {
        SubmitButton()
    }
}
