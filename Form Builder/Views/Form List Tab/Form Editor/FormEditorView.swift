//
//  FormEditorView.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/28/22.
//

import SwiftUI

// Display form with form tool bar
struct FormEditorView: View {
    
    @ObservedObject var form: Form
    @State var showExportView: Bool = false
    
    var body: some View {
        
        FormView(form: form)
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    EditorViewToolbar(form: form, showExportView: $showExportView)
                }
            })
    }
}

struct FormEditorView_Previews: PreviewProvider {
    static var previews: some View {
        FormEditorView(form: dev.form, showExportView: false)
    }
}
