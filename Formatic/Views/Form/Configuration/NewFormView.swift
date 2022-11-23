//
//  NewFormView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI
import FirebaseAnalytics

// Displays view to create new form
struct NewFormView: View {
    
    @FetchRequest(sortDescriptors: []) var forms: FetchedResults<Form>
    @EnvironmentObject var formModel: FormModel
    @Binding var showNewFormView: Bool
    @State var title = ""
    @State var password = ""
    @State var validTitle = false
    @State var validPassword = true
    @State var inRecentlyDeleted = false
    @State var isValid = false
    @State var showAlert = false
    @State var alertTitle = ""
    
    var body: some View {
        
        VStack (spacing: 20) {
            
            Text(Strings.newFormLabel)
                .font(.title)
            
            // Form title
            InputBox(placeholder: Strings.titleLabel, text: $title)
                .onChange(of: title) { _ in
                    withAnimation {
                        do {
                            (validTitle, inRecentlyDeleted) = try formModel.titleIsValid(title: title)
                        }
                        catch {
                            alertTitle = Strings.formTitleValidationErrorMessage
                            validTitle = false
                        }
                    }
                }
                .onChange(of: validTitle, perform: { _ in
                    withAnimation {
                        isValid = (validTitle && validPassword && !inRecentlyDeleted)
                    }
                })
                .alert(alertTitle, isPresented: $showAlert, actions: {
                    Button(Strings.defaultAlertButtonDismissMessage, role: .cancel) {}
                })
            
            PasswordView(validPassword: $validPassword, password: $password)
                .onChange(of: validPassword) { _ in
                    withAnimation {
                        isValid = (validTitle && validPassword)
                    }
                }
            
            // Submit button - create form and set lock if optional password is used
            Button {
                withAnimation {
                    let form = Form(title: title)
                    Analytics.logEvent(Strings.analyticsCreateFormEvent, parameters: nil)
                    if !password.isEmpty {
                        form.password = password
                        form.locked = true
                        Analytics.logEvent(Strings.analyticsCreateLockFormEvent, parameters: nil)
                    }
                }
                showNewFormView = false
                
            } label: {
                SubmitButton(isValid: $isValid)
            }
            .disabled(!(isValid))
            
            if !validTitle && !title.isEmpty {
                Text(Strings.formTitleAlreadyInUseErrorMessage + (inRecentlyDeleted ? ". " : "") + (inRecentlyDeleted ? Strings.formTitleInRecentlyDeletedErrorMessage : ""))
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            if !validPassword {
                Text(Strings.formPasswordDoesNotMatchErrorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding(.horizontal)
    }
}

struct NewFormView_Previews: PreviewProvider {
    static var previews: some View {
        NewFormView(showNewFormView: .constant(true))
    }
}
