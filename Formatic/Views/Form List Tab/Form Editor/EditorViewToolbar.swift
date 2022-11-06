//
//  EditorViewToolbar.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/29/22.
//

import SwiftUI

// Tool bar options for editing a form
struct EditorViewToolbar: View {
    
    @ObservedObject var form: Form
    @Binding var exportToForm: Bool
    @Binding var exportToPDF: Bool
    @Binding var exportToCSV: Bool
    @Binding var showToggleLockView: Bool
    @Binding var editMode: EditMode
    @State var alertTitle = ""
    @State var showAlert = false
    @State var alertButtonDismissMessage = Strings.defaultAlertButtonDismissMessage
    
    var body: some View {
        
        HStack {
            
            // Lock and unlock form button
            Button {
                if form.locked || (!form.locked && form.password == nil) {
                    showToggleLockView = true
                }
                else  {
                    withAnimation {
                        editMode = .inactive
                    }
                    form.locked = true
                }
            } label: {
                if FormModel.isPhone {
                    Image(systemName: form.locked == true ? Strings.lockIconName : Strings.openLockIconName)
                }
                else {
                    HStack {
                        Image(systemName: form.locked == true ? Strings.lockIconName : Strings.openLockIconName)
                        Text(form.locked == true ? Strings.lockedLabel : Strings.unlockedLabel)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            // Add section to form button
            Button {
                form.addToSections(Section(position: form.sections?.count ?? 0, title: nil))
            } label: {
                if FormModel.isPhone {
                    Image(systemName: Strings.plusCircleIconName)
                }
                else {
                    HStack {
                        Image(systemName: Strings.plusCircleIconName)
                        Text(Strings.newSectionLabel)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .disabled(form.locked)
            
            // Enable edit mode to rearrange list of widgets
            Button {
                withAnimation {
                    if editMode == .active {
                        editMode = .inactive
                    }
                    else {
                        editMode = .active
                    }
                }
            } label: {
                if FormModel.isPhone {
                    Image(systemName: Strings.editIconName)
                }
                else {
                    HStack {
                        Image(systemName: Strings.editIconName)
                        if editMode == .active {
                            Text(Strings.doneLabel)
                        }
                        else {
                            Text(Strings.editLabel)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .disabled(form.locked)
            
            // Export form button
            Menu {
                
                // Export to form button
                Button {
                    exportToForm = true
                } label: {
                    HStack {
                        Image(systemName: Strings.docZipperIconName)
                        Text(Strings.formLabel)
                    }
                }
                
                // Export to pdf button
                Button {
                    exportToPDF = true
                } label: {
                    HStack {
                        Image(systemName: Strings.docTextImageIconName)
                        Text(Strings.pdfLabel)
                    }
                }
                
                Button {
                    exportToCSV = true
                } label: {
                    HStack {
                        Image (systemName: Strings.csvTableIconName)
                        Text(Strings.csvLabel)
                    }
                }
            } label: {
                if FormModel.isPhone {
                    Image(systemName: Strings.exportFormIconName)
                }
                else {
                    HStack {
                        Image(systemName: Strings.exportFormIconName)
                        Text(Strings.exportLabel)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
        }
        .alert(alertTitle, isPresented: $showAlert, actions: {
            Button(alertButtonDismissMessage, role: .cancel) {}
        })
    }
}

struct EditorViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        EditorViewToolbar(form: dev.form, exportToForm: .constant(false), exportToPDF: .constant(false), exportToCSV: .constant(false), showToggleLockView: .constant(false), editMode: .constant(.inactive))
    }
}
