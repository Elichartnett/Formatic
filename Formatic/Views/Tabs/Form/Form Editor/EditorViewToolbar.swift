//
//  EditorViewToolbar.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/29/22.
//

import SwiftUI
import FirebaseAnalytics

// Tool bar options for editing a form
struct EditorViewToolbar: View {
    
    @EnvironmentObject var formModel: FormModel
    @ObservedObject var form: Form
    @Binding var exportToForm: Bool
    @Binding var exportToPDF: Bool
    @Binding var exportToCSV: Bool
    @Binding var showToggleLockView: Bool
    @Binding var editMode: EditMode
    @State var alertTitle = ""
    @State var showAlert = false
    
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
                let icon = Image(systemName: form.locked == true ? Strings.lockIconName : Strings.openLockIconName)
                if formModel.isPhone {
                    icon
                }
                else {
                    HStack {
                        icon
                        Text(form.locked == true ? Strings.lockedLabel : Strings.unlockedLabel)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            // Add section to form button
            Button {
                form.addToSections(Section(position: form.sections?.count ?? 0, title: nil))
                Analytics.logEvent(Strings.analyticsCreateSectionEvent, parameters: nil)
            } label: {
                if formModel.isPhone {
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
                let icon = Image(systemName: Strings.editIconName)
                if formModel.isPhone {
                    icon
                }
                else {
                    HStack {
                        icon
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
                let icon = Image(systemName: Strings.exportFormIconName)
                if formModel.isPhone {
                    icon
                }
                else {
                    HStack {
                        icon
                        Text(Strings.exportLabel)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
        }
        .alert(alertTitle, isPresented: $showAlert, actions: {
            Button(Strings.defaultAlertButtonDismissMessage, role: .cancel) {}
        })
    }
}

struct EditorViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        EditorViewToolbar(form: dev.form, exportToForm: .constant(false), exportToPDF: .constant(false), exportToCSV: .constant(false), showToggleLockView: .constant(false), editMode: .constant(.inactive))
    }
}
