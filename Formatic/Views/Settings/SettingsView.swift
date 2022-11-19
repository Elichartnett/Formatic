//
//  SettingsView.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/16/22.
//

import SwiftUI
import MessageUI

struct SettingsView: View {
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.dateCreated)], predicate: NSPredicate(format: "recentlyDeleted == true")) var recentlyDeletedForms: FetchedResults<Form>
    @EnvironmentObject var formModel: FormModel
    @State var showEmailVIew = false
    @State var expandRecentlyDeleted = false
    @State var alertTitle = ""
    @State var showAlert = false
    
    var body: some View {
        
        NavigationStack {
            
            SwiftUI.Form {
                
                SwiftUI.Section {
                    Text("\(Strings.versionLabel) \(Bundle.main.fullVersion)")
                    
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
                
                SwiftUI.Section {
                    HStack {
                        Text("\(Strings.recentlyDeletedFormsLabel) (\(recentlyDeletedForms.count))")
                        Image(systemName: Strings.expandListIconName)
                            .rotationEffect(Angle(degrees: expandRecentlyDeleted ? 90 : 0))
                    }
                    .onTapGesture {
                        if recentlyDeletedForms.count != 0 {
                            withAnimation {
                                expandRecentlyDeleted.toggle()
                            }
                        }
                    }
                    
                    if expandRecentlyDeleted {
                        ForEach(recentlyDeletedForms) { form in
                            Text(form.title ?? "")
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle(Strings.settingsLabel)
            .scrollContentBackground(.hidden)
            .background(Color.primaryBackground)
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
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
                .environmentObject(FormModel())
        }
    }
}
