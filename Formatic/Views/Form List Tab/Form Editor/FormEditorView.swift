//
//  FormEditorView.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/28/22.
//

import SwiftUI
import UniformTypeIdentifiers

// Display form with form tool bar
struct FormEditorView: View {
    
    @EnvironmentObject var formModel: FormModel
    
    @ObservedObject var form: Form
    @State var formaticFileDocument: FormaticFileDocument?
    @State var exportToForm = false
    @State var exportToPDF = false
    @State var exportToCSV = false
    @State var showFileExporter = false
    @State var showToggleLockView = false
    @State var isEditing = false
    @State var showAlert = false
    @State var alertTitle = ""
    @State var alertMessage = "Okay"
    @State var exportFormat: UTType?
    
    var body: some View {
        
        VStack {
            
            FormView(form: form, forPDF: false)
                .environment(\.editMode, .constant(isEditing ? .active : .inactive))
                .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        EditorViewToolbar(form: form, exportToForm: $exportToForm, exportToPDF: $exportToPDF, exportToCSV: $exportToCSV, showToggleLockView: $showToggleLockView, isEditing: $isEditing)
                    }
                })
                .onChange(of: exportToForm, perform: { _ in
                    if exportToForm {
                        exportFormat = .form
                        do {
                            let formData = try formModel.encodeFormToJsonData(form: form)
                            formaticFileDocument = FormaticFileDocument(documentData: formData)
                            showFileExporter = true
                        }
                        catch {
                            alertTitle = "Error exporting form"
                            showAlert = true
                        }
                        exportToForm = false
                    }
                })
                .onChange(of: exportToPDF, perform: { _ in
                    if exportToPDF {
                        exportFormat = .pdf
                        let pdfData = formModel.exportToPdf(form: form)
                        formaticFileDocument = FormaticFileDocument(documentData: pdfData)
                        showFileExporter = true
                        exportToPDF = false
                    }
                })
                .onChange(of: exportToCSV, perform: { _ in
                    if exportToCSV {
                        exportFormat = .commaSeparatedText
                        let csvData = formModel.exportToCsv(form: form)
                        formaticFileDocument = FormaticFileDocument(documentData: csvData)
                        showFileExporter = true
                        exportToCSV = false
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
                .fileExporter(isPresented: $showFileExporter, document: formaticFileDocument, contentType: exportFormat ?? .form, defaultFilename: form.title, onCompletion: { result in
                    switch result {
                    case .success(_):
                        return
                    case .failure(_):
                        alertTitle = "Error exporting form"
                        showAlert = true
                    }
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
                .environment(\.managedObjectContext, DataControllerModel.shared.container.viewContext)
        }
        .navigationViewStyle(.stack)
    }
}
