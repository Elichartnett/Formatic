//
//  SettingsView.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/16/22.
//

import SwiftUI
import MessageUI

struct SettingsView: View {
    
    @Environment(\.openURL) private var openURL
    @FetchRequest(sortDescriptors: [SortDescriptor(\.dateCreated)], predicate: NSPredicate(format: Constants.predicateRecentlyDeletedEqualToTrue)) var recentlyDeletedForms: FetchedResults<Form>
    @EnvironmentObject var formModel: FormModel
    
    @State var showEmailVIew = false
    @State var expandRecentlyDeleted = false
    @State var selectedForms = Set<Form>()
    @State var alertTitle = ""
    @State var showAlert = false
    @State var showPaywallView = false
    @State var showTutorialView = false
    
    var body: some View {
        
        NavigationStack {
            
            List(selection: $selectedForms) {
                
                SwiftUI.Section {
                    versionLabel
                    
                    HStack {
                        Image(systemName: Constants.dollarSignFilledIconName)
                            .customIcon(foregroundColor: .green)
                        showPaywallViewButton
                    }
                    
                    HStack {
                        Image(systemName: Constants.tutorialIconName)
                            .customIcon(foregroundColor: .brown)
                        showTutorialViewButton
                    }
                    
                    HStack {
                        Image(systemName: Constants.supportFilledIconName)
                            .customIcon(foregroundColor: .purple)
                        submitFeedbackButton
                    }
                    
                    HStack {
                        Image(systemName: Constants.starFilledIconName)
                            .customIcon(foregroundColor: .yellow)
                        writeAReviewButton
                    }
                }
                
                SwiftUI.Section {
                    HStack {
                        recentlyDeletedDropdownArrow
                        
                        Spacer()
                        
                        multiWidgetSelectionToolBar
                            .opacity(!selectedForms.isEmpty && expandRecentlyDeleted ? 1 : 0)
                            .animation(.default, value: selectedForms.isEmpty)
                    }
                    
                    if expandRecentlyDeleted {
                        recentlyDeletedList
                    }
                }
            }
            .environment(\.editMode, .constant(.active))
            .navigationTitle(Strings.settingsLabel)
            .scrollContentBackground(.hidden)
            .background(Color.primaryBackground)
            .sheet(isPresented: $showPaywallView, content: {
                PaywallView(storeKitManager: formModel.storeKitManager)
            })
            .sheet(isPresented: $showTutorialView, content: {
                TutorialView(tabs: [.icons, .tips]) {
                    showTutorialView = false
                }
            })
            .sheet(isPresented: $showEmailVIew) {
                let body = FormModel.getDeviceInformation()
                let emailData = EmailData(subject: Strings.formaticFeedbackLabel, recipients: [Strings.emailAddress], body: body)
                
                EmailViewRepresentable(emailData: emailData) { result in
                    switch result {
                    case .success(_):
                        break
                        
                    case .failure(_):
                        alertTitle = Strings.failedToSendEmailErrorMessage
                        showAlert = true
                    }
                }
            }
            .alert(alertTitle, isPresented: $showAlert, actions: {
                Button(Strings.copyAddressLabel, role: .cancel) {
                    UIPasteboard.general.string = Strings.emailAddress
                }
            })
        }
    }
    
    var versionLabel: some View {
        Text("\(Strings.versionLabel) \(Bundle.main.fullVersion)")
    }
    
    var showTutorialViewButton: some View {
        Button {
            showTutorialView = true
        } label: {
            Text("Tutorial")
        }
    }
    
    var showPaywallViewButton: some View {
        Button {
            showPaywallView = true
        } label: {
            Text(Strings.inAppPurchasesLabel)
        }
    }
    
    var submitFeedbackButton: some View {
        Button {
            if EmailViewRepresentable.canSendEmail() {
                showEmailVIew = true
            }
            else {
                if let url = URL(string: "mailto:\(Strings.emailAddress)") {
                    alertTitle = Strings.failedToOpenEmailURLErrorMessage
                    showAlert = true
                    if UIApplication.shared.canOpenURL(url)
                    {
                        UIApplication.shared.open(url)
                    }
                    else {
                        alertTitle = Strings.failedToOpenEmailURLErrorMessage
                        showAlert = true
                    }
                }
                else {
                    alertTitle = Strings.failedToCreateEmailURLErrorMessage
                    showAlert = true
                }
            }
        } label: {
            Text(Strings.submitFeedbackLabel)
        }
    }
    
    var writeAReviewButton: some View {
        Group {
            if let url = URL(string: "https://apps.apple.com/app/id\(Constants.appID)?action=write-review") {
                Button {
                    openURL(url)
                } label: {
                    Text(Strings.writeAReviewLabel)
                }
            }
        }
    }
    
    var recentlyDeletedDropdownArrow: some View {
        Button {
            if recentlyDeletedForms.count != 0 {
                withAnimation {
                    expandRecentlyDeleted.toggle()
                }
            }
        } label: {
            HStack {
                Text("\(Strings.recentlyDeletedFormsLabel) (\(recentlyDeletedForms.count))")
                    .foregroundColor(.primary)
                Image(systemName: Constants.expandListIconName)
                    .customIcon(foregroundColor: recentlyDeletedForms.isEmpty ? .customGray : .blue)
                    .rotationEffect(Angle(degrees: expandRecentlyDeleted ? 90 : 0))
            }
        }
        .onChange(of: selectedForms) { _ in
            if selectedForms.isEmpty && recentlyDeletedForms.isEmpty {
                expandRecentlyDeleted = false
            }
        }
    }
    
    var multiWidgetSelectionToolBar: some View {
        HStack {
            let recoverLabel = Labels.recover
                .foregroundColor(.blue)
                .onTapGesture {
                    withAnimation {
                        for form in selectedForms {
                            form.recentlyDeleted = false
                        }
                        selectedForms.removeAll()
                    }
                }
            
            if formModel.isPhone {
                recoverLabel.labelStyle(.iconOnly)
            }
            else {
                recoverLabel.labelStyle(.titleAndIcon)
            }
            
            let deleteLabel = Labels.delete
                .foregroundColor(.red)
                .onTapGesture {
                    withAnimation {
                        for form in selectedForms {
                            form.delete()
                        }
                        selectedForms.removeAll()
                    }
                }
            
            if formModel.isPhone {
                deleteLabel.labelStyle(.iconOnly)
            }
            else {
                deleteLabel.labelStyle(.titleAndIcon)
            }
        }
    }
    
    var recentlyDeletedList: some View {
        ForEach(recentlyDeletedForms, id: \.self) { form in
            Text(form.title ?? "")
                .swipeActions {
                    Button {
                        withAnimation {
                            form.delete()
                            if recentlyDeletedForms.isEmpty {
                                expandRecentlyDeleted = false
                            }
                        }
                    } label: {
                        Label(Strings.deleteLabel, systemImage: Constants.trashIconName)
                    }
                    .tint(.red)
                    
                    Button {
                        
                    } label: {
                        Label(Strings.recoverLabel, systemImage: Constants.plusIconName)
                    }
                    .tint(.blue)
                }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
                .environmentObject(FormModel())
        }
    }
}
