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
    @State var exportToPDF = false
    @State var exportToCSV = false
    @State var showToggleLockView = false
    @State var showAlert = false
    @State var alertTitle = ""
    
    var body: some View {
        VStack {
            FormView(form: form, forPDF: false)
                .environment(\.editMode, $editMode)
                .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        EditorViewToolbar(form: form, showToggleLockView: $showToggleLockView, editMode: $editMode)
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
                .sheet(isPresented: $showToggleLockView, onDismiss: {
                    if form.locked == true {
                        withAnimation {
                            editMode = .inactive
                        }
                    }
                }, content: {
                    ToggleLockView(showToggleLockView: $showToggleLockView, form: form)
                })
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
