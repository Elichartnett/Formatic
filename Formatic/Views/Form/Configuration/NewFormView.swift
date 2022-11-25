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
    @State var validPassword = true
    @State var inRecentlyDeleted = false
    @State var showAlert = false
    @State var alertTitle = ""
    
    var body: some View {
        
        VStack (spacing: 20) {
            
            Text(Strings.newFormLabel)
                .font(.title)
            
            // Form title
            InputBox(placeholder: Strings.titleLabel, text: $title)
                .alert(alertTitle, isPresented: $showAlert, actions: {
                    Button(Strings.defaultAlertButtonDismissMessage, role: .cancel) {}
                })
            
            PasswordView(validPassword: $validPassword, password: $password)
            
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
                SubmitButton()
            }
            .disabled(!validPassword)
            
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
