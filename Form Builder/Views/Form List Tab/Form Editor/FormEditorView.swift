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
    @State var showExportToPDFView: Bool = false
    @State var showExportToTemplateView: Bool = false
    
    var body: some View {
        
        FormView(form: form)
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    EditorViewToolbar(form: form, showExportToPDFView: $showExportToPDFView, showExportToTemplateView: $showExportToTemplateView)
                }
            })
    }
}

struct FormEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FormEditorView(form: dev.form)
        }
        .navigationViewStyle(.stack)
    }
}
