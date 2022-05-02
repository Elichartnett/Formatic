//
//  SubmitButton.swift
//  Form Builder
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

// Standard submit button label
struct SubmitButton: View {
    
    @State var color: Color = .blue
    
    var body: some View {
        
        Rectangle()
            .fill(color)
            .frame(width: 300, height: 100)
            .cornerRadius(10)
            .overlay(
                Text("Submit")
                    .font(.title)
                    .foregroundColor(.primary)
            )
    }
}

struct SubmitButton_Previews: PreviewProvider {
    static var previews: some View {
        SubmitButton()
    }
}
