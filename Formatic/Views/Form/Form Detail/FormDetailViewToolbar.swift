//
//  EditorViewToolbar.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/29/22.
//

import SwiftUI
import FirebaseAnalytics
import UniformTypeIdentifiers

struct FormDetailViewToolbar: View {
    
    @Environment(\.editMode) var editMode
    @EnvironmentObject var formModel: FormModel
    
    @ObservedObject var form: Form
    @State var exportType: UTType?
    @Binding var showToggleLockView: Bool
    @State var alertTitle = ""
    @State var showAlert = false
    
    var body: some View {
        
        HStack {
            Spacer()
            
            addSectionButton
                .disabled(form.locked)
            
            Spacer()
            
            lockFormButton
            
            Spacer()
            
            EditModeButton(disabled: form.locked, onTap: {})
            
            Spacer()
            
            ExportMenuButton(storeKitManager: formModel.storeKitManager, exportType: $exportType, forms: [form])
            
            Spacer()
        }
        .sheet(item: $exportType, content: { exportType in
            ExportView(forms: [form], exportType: $exportType)
        })
        .alert(alertTitle, isPresented: $showAlert, actions: {
            Button(Strings.defaultAlertButtonDismissMessage, role: .cancel) {}
        })
    }
    
    var addSectionButton: some View {
        Button {
            let section = Section(position: form.sections?.count ?? 0, title: nil)
            form.addToSections(section)
            Analytics.logEvent(Constants.analyticsCreateSectionEvent, parameters: nil)
        } label: {
            let icon = Image(systemName: Constants.plusCircleIconName)
            if formModel.isPhone {
                icon
            }
            else {
                HStack {
                    icon
                    Text(Strings.newSectionLabel)
                }
            }
        }
        .accessibilityLabel(Strings.newSectionLabel)
    }
    
    var lockFormButton: some View {
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
            let icon = Image(systemName: form.locked == true ? Constants.lockIconName : Constants.openLockIconName)
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
    }
}

struct EditorViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        FormDetailViewToolbar(form: dev.form, showToggleLockView: .constant(false))
            .environmentObject(FormModel())
    }
}
