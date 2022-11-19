//
//  FormEditorView.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/28/22.
//

import SwiftUI
import UniformTypeIdentifiers
import FirebaseAnalytics

// Display form with form tool bar
struct FormEditorView: View {
    
    @EnvironmentObject var formModel: FormModel
    @State var editMode = EditMode.inactive
    @ObservedObject var form: Form
    @State var formaticFileDocument: FormaticFileDocument?
    @State var exportToForm = false
    @State var exportToPDF = false
    @State var exportToCSV = false
    @State var showFileExporter = false
    @State var showToggleLockView = false
    @State var showAlert = false
    @State var alertTitle = ""
    @State var exportFormat: UTType?
    
    var body: some View {
        VStack {
            FormView(form: form, forPDF: false)
                .environment(\.editMode, $editMode)
                .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        EditorViewToolbar(form: form, exportToForm: $exportToForm, exportToPDF: $exportToPDF, exportToCSV: $exportToCSV, showToggleLockView: $showToggleLockView, editMode: $editMode)
                    }
                    
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        
                        Button {
                            FormModel.endEditing()
                        } label: {
                            Text(Strings.doneLabel)
                        }
                    }
                })
                .onChange(of: exportToForm, perform: { _ in
                    if exportToForm {
                        exportFormat = .form
                        DispatchQueue.main.async {
                            do {
                                let formData = try formModel.encodeFormToJsonData(form: form)
                                formaticFileDocument = FormaticFileDocument(documentData: formData)
                                Analytics.logEvent(Strings.analyticsExportFormEvent, parameters: nil)
                                showFileExporter = true
                            }
                            catch {
                                alertTitle = Strings.exportFormErrorMessage
                                showAlert = true
                            }
                            exportToForm = false
                        }
                    }
                })
                .onChange(of: exportToPDF, perform: { _ in
                    if exportToPDF {
                        exportFormat = .pdf
                        DispatchQueue.main.async {
                            let pdfData = formModel.exportToPdf(form: form)
                            formaticFileDocument = FormaticFileDocument(documentData: pdfData)
                            Analytics.logEvent(Strings.analyticsExportPDFEvent, parameters: nil)
                            exportToPDF = false
                            showFileExporter = true
                        }
                    }
                })
                .onChange(of: exportToCSV, perform: { _ in
                    if exportToCSV {
                        exportFormat = .commaSeparatedText
                        DispatchQueue.main.async {
                            let csvData = formModel.exportToCsv(form: form)
                            formaticFileDocument = FormaticFileDocument(documentData: csvData)
                            Analytics.logEvent(Strings.analyticsExportCSVEvent, parameters: nil)
                            showFileExporter = true
                            exportToCSV = false
                        }
                    }
                })
                .sheet(isPresented: $showToggleLockView, onDismiss: {
                    if form.locked == true {
                        withAnimation {
                            editMode = .inactive
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
                        alertTitle = Strings.exportFormErrorMessage
                        showAlert = true
                    }
                })
                .overlay {
                    if exportToForm || exportToPDF || exportToCSV {
                        ProgressView()
                    }
                }
                .alert(alertTitle, isPresented: $showAlert, actions: {
                    Button(Strings.defaultAlertButtonDismissMessage, role: .cancel) {}
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
