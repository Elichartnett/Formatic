//
//  EndEditingButton.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/25/22.
//

import SwiftUI

struct EndEditingButton: View {
    var body: some View {
        Button {
            FormModel.endEditing()
        } label: {
            Text(Strings.doneLabel)
                .foregroundColor(.blue)
        }
    }
}

struct EndEditingButton_Previews: PreviewProvider {
    static var previews: some View {
        EndEditingButton()
    }
}
