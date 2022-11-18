//
//  SettingsView.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/16/22.
//

import SwiftUI
import MessageUI

struct SettingsView: View {
    
    @EnvironmentObject var formModel: FormModel
    @State var showEmailVIew = false
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
            }
            .navigationTitle(Strings.settingsLabel)
            .scrollContentBackground(.hidden)
            .background(Color.primaryBackground)
            .sheet(isPresented: $showEmailVIew) {
                let body = """
                -----------------------------
                Device: \(UIDevice.current.name)
                Device Version: \(UIDevice.current.systemVersion)
                Formatic Version: \(Bundle.main.fullVersion)
                -----------------------------
                \n
                """
                let emailData = EmailData(subject: "Formatic Feedback", recipients: [Strings.emailAddress], body: body)
                
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
