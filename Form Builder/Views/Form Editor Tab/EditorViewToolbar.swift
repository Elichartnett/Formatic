//
//  EditorViewToolbar.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/29/22.
//

import SwiftUI

struct EditorViewToolbar: View {
    
    @ObservedObject var form: Form
    
    var body: some View {
        
        // Tool bar options for editing a form
        HStack {
            
            Spacer()
            
            Button {
                form.locked.toggle()
            } label: {
                HStack {
                    Image(systemName: form.locked ? "lock" : "lock.open")
                    Text(form.locked ? "Locked" : "Unlocked")
                }
            }
            
            Spacer()
            
            Button {
                // TODO: New section in form
            } label: {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("New section")
                }
            }
            
            Spacer()
            
            Button {
                // TODO: Export
            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Export")
                }
            }
            
            Spacer()
        }
    }
}

struct EditorViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        EditorViewToolbar(form: dev.form)
    }
}
