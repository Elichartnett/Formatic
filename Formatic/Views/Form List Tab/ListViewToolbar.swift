//
//  ListViewToolbar.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/29/22.
//

import SwiftUI

// Tool bar options for list of saved forms
struct ListViewToolbar: View {
    
    @Binding var showNewFormView: Bool
    @Binding var showImportFormView: Bool
    
    var body: some View {
        
        HStack {
            
            Spacer()
            
            // Create new form button
            Button {
                showNewFormView = true
            } label: {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("New form")
                }
            }
            
            Spacer()
            
            // Import form button
            Button {
                showImportFormView = true
            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.down")
                    Text("Import")
                }
            }
            
            Spacer()
        }
    }
}

struct ListViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        ListViewToolbar(showNewFormView: .constant(false), showImportFormView: .constant(false))
    }
}
