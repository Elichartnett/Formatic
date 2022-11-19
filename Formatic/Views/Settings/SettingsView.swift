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
    @State var selectedForms: [Form] = []
    @State var alertTitle = ""
    @State var showAlert = false
    
    var body: some View {
        
        NavigationStack {
            
            List {
                
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
                                Image(systemName: Strings.expandListIconName)
                                    .rotationEffect(Angle(degrees: expandRecentlyDeleted ? 90 : 0))
                            }
                        }
                        .onChange(of: selectedForms.isEmpty) { _ in
                            if selectedForms.isEmpty {
                                expandRecentlyDeleted = false
                            }
                        }
                        
                        Spacer()
                        
                        
                        Image(systemName: Strings.plusIconName)
                            .customIcon()
                            .onTapGesture {
                                withAnimation {
                                    for form in selectedForms {
                                        form.recentlyDeleted = false
                                    }
                                    selectedForms.removeAll()
                                }
                            }
                            .opacity(!selectedForms.isEmpty && expandRecentlyDeleted ? 1 : 0)
                            .animation(.default, value: selectedForms.isEmpty)
                        
                        Image(systemName: Strings.trashIconName)
                            .customIcon()
                            .onTapGesture {
                                withAnimation {
                                    for form in selectedForms {
                                        formModel.deleteForm(form: form)
                                    }
                                    selectedForms.removeAll()
                                }
                            }
                            .opacity(!selectedForms.isEmpty && expandRecentlyDeleted ? 1 : 0)
                            .animation(.default, value: selectedForms.isEmpty)
                    }
                    
                    if expandRecentlyDeleted {
                        ForEach(recentlyDeletedForms) { form in
                            let selected = selectedForms.contains(form)
                            HStack {
                                Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(Color(uiColor: selected ? .systemBlue : .customGray))
                                Text(form.title ?? "")
                            }
                            .onTapGesture {
                                if selected {
                                    selectedForms.removeAll { selectedForm in
                                        selectedForm.id == form.id
                                    }
                                }
                                else {
                                    selectedForms.append(form)
                                }
                            }
                        }
                        .alignmentGuide(.listRowSeparatorLeading, computeValue: { viewDimensions in
                            return 0
                        })
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
