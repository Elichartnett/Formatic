//
//  FormEditorView.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/28/22.
//

import SwiftUI

// Display form with form tool bar
struct FormEditorView: View {
    
    @EnvironmentObject var model: FormModel
    @ObservedObject var form: Form
    @State var formaticFileDocument: FormaticFileDocument?
    @State var showExportToPDFView: Bool = false
    @State var exportToTemplate: Bool = false
    @State var showExportToTemplateView: Bool = false
    @State var showToggleLockView: Bool = false
    @State var isEditing: Bool = false
    @State var showAlert: Bool = false
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""
    
    var body: some View {
        
        VStack {
            FormView(form: form)
                .environment(\.editMode, .constant(isEditing ? .active : .inactive))
                .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        EditorViewToolbar(form: form, showExportToPDFView: $showExportToPDFView, exportToTemplate: $exportToTemplate, showToggleLockView: $showToggleLockView, isEditing: $isEditing)
                    }
                })
                .onChange(of: exportToTemplate, perform: { _ in
                    if exportToTemplate {
                        do {
                            formaticFileDocument = try  FormaticFileDocument(jsonData: model.encodeFormToJsonData(form: form))
                            showExportToTemplateView = true
                        }
                        catch {
                            showAlert = true
                        }
                    }
                })
                .sheet(isPresented: $showToggleLockView) {
                    ToggleLockView(showToggleLockView: $showToggleLockView, form: form)
                }
                .fileExporter(isPresented: $showExportToTemplateView, document: formaticFileDocument, contentType: .form, defaultFilename: form.title ?? form.id.uuidString) { result in
                }
                .alert(alertTitle, isPresented: $showAlert, actions: {
                    Button(alertMessage, role: .cancel) {}
                })
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
