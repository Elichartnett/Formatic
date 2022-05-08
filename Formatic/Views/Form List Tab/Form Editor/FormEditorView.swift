//
//  FormEditorView.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/28/22.
//

import SwiftUI

// Display form with form tool bar
struct FormEditorView: View {
    
    @ObservedObject var form: Form
    @State var showExportToPDFView: Bool = false
    @State var showExportToTemplateView: Bool = false
    @State var showToggleLockView: Bool = false
    @State var isEditing: Bool = false
    
    var body: some View {
        
        VStack {
            FormView(form: form)
                .environment(\.editMode, .constant(isEditing ? .active : .inactive))
                .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        EditorViewToolbar(form: form, showExportToPDFView: $showExportToPDFView, showExportToTemplateView: $showExportToTemplateView, showToggleLockView: $showToggleLockView, isEditing: $isEditing)
                    }
            })
                .sheet(isPresented: $showToggleLockView) {
                    ToggleLockView(showToggleLockView: $showToggleLockView, form: form)
                }
        }
    }
}

struct FormEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FormEditorView(form: dev.form)
                .environmentObject(FormModel())
        }
        .navigationViewStyle(.stack)
    }
}
