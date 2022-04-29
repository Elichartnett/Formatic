//
//  FormEditorView.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/28/22.
//

import SwiftUI

struct FormEditorView: View {
    
    @EnvironmentObject var formModel: FormModel
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                // Edit active form
                if let form = formModel.activeForm {
                    FormView(form: form)
                }
                else {
                    Spacer()
                    
                    Text("No active form")
                    
                    Spacer()
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    EditorViewToolbar(form: formModel.activeForm ?? Form(title: ""))
                        .disabled(formModel.activeForm?.locked ?? true)
                }
            })
        }
        .navigationViewStyle(.stack)
    }
}

struct FormEditorView_Previews: PreviewProvider {
    static var previews: some View {
        FormEditorView()
            .environmentObject(FormModel())
    }
}
