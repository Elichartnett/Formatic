//
//  EndEditingButton.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/25/22.
//

import SwiftUI

struct FormaticToolbar: ToolbarContent {
    
    @EnvironmentObject var formModel: FormModel
    
    var body: some ToolbarContent {
        
        ToolbarItemGroup(placement: .keyboard) {
            
            Spacer()
            
            Button {
                FormModel.endEditing()
            } label: {
                Text(Strings.doneLabel)
                    .foregroundColor(.blue)
            }
        }
    }
}
