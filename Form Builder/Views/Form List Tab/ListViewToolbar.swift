//
//  ListViewToolbar.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/29/22.
//

import SwiftUI

struct ListViewToolbar: View {
    
    var body: some View {
        
        // Tool bar options for list of saved forms
        HStack {
            
            Spacer()
            
            // Create new form
            Button {
                let _ = Form(title: "title here")
                DataController.saveMOC()
            } label: {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("New form")
                }
            }
            
            Spacer()
            
            // Import form
            Button {
                //TODO: Import form functionality
            } label: {
                HStack {
                    Image(systemName: "square.and.arroy.down")
                    Text("Import template")
                }
            }
            
            Spacer()
        }
    }
}

struct ListViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        ListViewToolbar()
    }
}
