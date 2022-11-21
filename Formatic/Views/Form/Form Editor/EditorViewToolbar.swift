//
//  EditorViewToolbar.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/29/22.
//

import SwiftUI
import FirebaseAnalytics
import UniformTypeIdentifiers

// Tool bar options for editing a form
struct EditorViewToolbar: View {
    
    @EnvironmentObject var formModel: FormModel
    @ObservedObject var form: Form
    @State var exportType: UTType?
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
                        .foregroundColor(editMode == .active ? .primaryBackground : .blue)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(editMode == .active ? .blue : Color.primaryBackground)
                        }
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
                
                // Export to form
                ShareLink(item: form, preview: SharePreview(form.title ?? "Form"))
                
                // Export to PDF
                Button {
                    exportType = .pdf
                } label: {
                    HStack {
                        Image(systemName: Strings.docTextImageIconName)
                        Text(Strings.generatePDFLabel)
                    }
                }
                
                // Export to CSV
                Button {
                    exportType = .commaSeparatedText
                } label: {
                    HStack {
                        Image (systemName: Strings.csvTableIconName)
                        Text(Strings.generateCSVLabel)
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
        .sheet(item: $exportType, content: { exportType in
            ExportView(form: form, exportType: $exportType)
        })
        .alert(alertTitle, isPresented: $showAlert, actions: {
            Button(Strings.defaultAlertButtonDismissMessage, role: .cancel) {}
        })
    }
}

struct EditorViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        EditorViewToolbar(form: dev.form, showToggleLockView: .constant(false), editMode: .constant(.inactive))
    }
}
