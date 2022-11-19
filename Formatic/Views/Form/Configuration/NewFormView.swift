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
    @State var title: String = ""
    @State var password: String = ""
    @State var validTitle: Bool = false
    @State var validPassword: Bool = true
    @State var isValid: Bool = false
    @State var showAlert: Bool = false
    @State var alertTitle: String = ""
    
    var body: some View {
        
        VStack (spacing: 20) {
            
            Text(Strings.newFormLabel)
                .font(.title)
            
            // Form title
            InputBox(placeholder: Strings.titleLabel, text: $title)
                .onChange(of: title) { _ in
                    do {
                        validTitle = try formModel.titleIsValid(title: title)
                    }
                    catch {
                        alertTitle = Strings.formTitleValidationErrorMessage
                        validTitle = false
                    }
                }
                .onChange(of: validTitle, perform: { _ in
                    withAnimation {
                        isValid = (validTitle && validPassword)
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
                Text(Strings.formTitleAlreadyInUseErrorMessage)
                    .foregroundColor(.red)
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