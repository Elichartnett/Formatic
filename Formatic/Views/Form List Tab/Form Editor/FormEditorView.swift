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
    @State var exportToForm: Bool = false
    @State var exportToPDF: Bool = false
    @State var exportToCSV: Bool = false
    @State var showFileExporter: Bool = false
    @State var showToggleLockView: Bool = false
    @State var isEditing: Bool = false
    @State var showAlert: Bool = false
    @State var alertTitle: String = ""
    @State var alertMessage: String = "Okay"
    @State private var exportFormat: UTType?
    
    var body: some View {
        
        VStack {
            FormView(form: form, forPDF: false)
                .environment(\.editMode, .constant(isEditing ? .active : .inactive))
                .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        EditorViewToolbar(form: form, exportToForm: $exportToForm, exportToPDF: $exportToPDF, exportToCSV: $exportToCSV, showToggleLockView: $showToggleLockView, isEditing: $isEditing)
                    }
                })
                .onChange(of: exportToPDF, perform: { _ in
                    if exportToPDF {
                        exportFormat = .pdf
                        let pdfData = formModel.exportToPDF(form: form)
                        formaticFileDocument = FormaticFileDocument(documentData: pdfData)
                        showFileExporter = true
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
                    }
                })
                .onChange(of: exportToCSV, perform: { _ in
                    if exportToCSV {
                        exportFormat = .commaSeparatedText
                        let csvData = formModel.exportToCSV(form: form)
                        formaticFileDocument = FormaticFileDocument(documentData: csvData)
                        showFileExporter = true
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
