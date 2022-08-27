//
//  FormEditorView.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/28/22.
//

import SwiftUI

// Display form with form tool bar
struct FormEditorView: View {
    
    @EnvironmentObject var formModel: FormModel
    
    @ObservedObject var form: Form
    @State var formaticFileDocument: FormaticFileDocument?
    @State var exportToTemplate: Bool = false
    @State var exportToPDF: Bool = false
    @State var showFileExporter: Bool = false
    @State var showToggleLockView: Bool = false
    @State var isEditing: Bool = false
    @State var showAlert: Bool = false
    @State var alertTitle: String = ""
    @State var alertMessage: String = "Okay"
    
    var body: some View {
        
        VStack {
            FormView(form: form, forPDF: false)
                .environment(\.editMode, .constant(isEditing ? .active : .inactive))
                .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        EditorViewToolbar(form: form, exportToTemplate: $exportToTemplate, exportToPDF: $exportToPDF, showToggleLockView: $showToggleLockView, isEditing: $isEditing)
                    }
                })
                .onChange(of: exportToPDF, perform: { _ in
                    if exportToPDF {
                        let pdfData = formModel.exportToPDF(form: form)
                        formaticFileDocument = FormaticFileDocument(documentData: pdfData)
                        showFileExporter = true
                    }
                })
                .onChange(of: exportToTemplate, perform: { _ in
                    if exportToTemplate {
                        do {
                            let formData = try formModel.encodeFormToJsonData(form: form)
                            formaticFileDocument = FormaticFileDocument(documentData: formData)
                            showFileExporter = true
                        }
                        catch {
                            alertTitle = "Error exporting form to template"
                            showAlert = true
                        }
                    }
                })
                .sheet(isPresented: $showToggleLockView, onDismiss: {
                    if form.locked == true {
                        withAnimation {
                            isEditing = false
                        }
                    }
                }, content: {
                    ToggleLockView(showToggleLockView: $showToggleLockView, form: form)
                })
                .fileExporter(isPresented: $showFileExporter, document: formaticFileDocument, contentType: exportToPDF ? .pdf : .form, defaultFilename: form.title, onCompletion: { result in
                    exportToPDF = false
                })
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
                .environment(\.managedObjectContext, DataController.shared.container.viewContext)
        }
        .navigationViewStyle(.stack)
    }
}
