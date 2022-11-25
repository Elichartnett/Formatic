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
    
    @Environment(\.editMode) var editMode
    @EnvironmentObject var formModel: FormModel
    @ObservedObject var form: Form
    @State var exportType: UTType?
    @Binding var showToggleLockView: Bool
    @State var alertTitle = ""
    @State var showAlert = false
    
    var body: some View {
        
        HStack {
            
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
            
            // Lock and unlock form button
            Button {
                if form.locked || (!form.locked && form.password == nil) {
                    showToggleLockView = true
                }
                else  {
                    withAnimation {
                        editMode?.wrappedValue = .inactive
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
            
            // Enable edit mode to rearrange list of widgets
            EditModeButton(onTap: {})
            .disabled(form.locked)
            
            ExportMenuButton(exportType: $exportType, forms: [form])
            .frame(maxWidth: .infinity)
            
        }
        .sheet(item: $exportType, content: { exportType in
            ExportView(forms: [form], exportType: $exportType)
        })
        .alert(alertTitle, isPresented: $showAlert, actions: {
            Button(Strings.defaultAlertButtonDismissMessage, role: .cancel) {}
        })
    }
}

struct EditorViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        EditorViewToolbar(form: dev.form, showToggleLockView: .constant(false))
    }
}
