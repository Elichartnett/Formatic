//
//  FormEditorView.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/28/22.
//

import SwiftUI

struct FormEditorView: View {
    
    @Environment(\.editMode) var editMode
    
    @ObservedObject var form: Form
    @State var exportToPDF = false
    @State var exportToCSV = false
    @State var showToggleLockView = false
    @State var showAlert = false
    @State var alertTitle = ""
    
    var body: some View {
        VStack {
            FormView(form: form, forPDF: false)
                .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        EditorViewToolbar(form: form, showToggleLockView: $showToggleLockView)
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
                            editMode?.wrappedValue = .inactive
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
                .environment(\.managedObjectContext, DataControllerModel.shared.container.viewContext)
        }
        .navigationViewStyle(.stack)
    }
}
