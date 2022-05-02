//
//  NewFormView.swift
//  Form Builder
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

// Displays view to create new formo
struct NewFormView: View {
    
    @FetchRequest(sortDescriptors: []) var forms: FetchedResults<Form>
    
    @Binding var showNewFormView: Bool
    @State var title: String = ""
    @State var password: String = ""
    @State var showPasswordConfirmation: Bool = false
    @State var passwordConfirmation: String = ""
    var isValid: Bool {
        if !title.isEmpty && !forms.contains(where: { form in
            form.title == title
        }) && password == passwordConfirmation {
            return true
        }
        else {
            return false
        }
    }
    
    var body: some View {
        
        VStack (spacing: 20) {
            
            Text("New Form")
                .font(.title)
            
            // Form title
            InputBox(placeholder: "Title", text: $title)
            
            // Optional form password
            InputBox(placeholder: "Optional password", text: $password, inputType: .password)
                .onChange(of: password) { _ in
                    if !password.isEmpty {
                        withAnimation {
                            showPasswordConfirmation = true
                        }
                    }
                    else {
                        withAnimation {
                            showPasswordConfirmation = false
                        }
                    }
                }
            
            // Confirm password if used
            if showPasswordConfirmation {
                InputBox(placeholder: "Retype password", text: $passwordConfirmation, inputType: .password)
            }

            // Create form and set lock if a password is set
            Button {
                let form = Form(title: title)
                if !password.isEmpty {
                    form.password = password
                    form.locked = true
                }
                DataController.saveMOC()
                showNewFormView = false
            } label: {
                if isValid {
                    SubmitButton(color: .blue)
                }
                else {
                    SubmitButton(color: .gray)
                }
            }
            .disabled(isValid == true ? false : true)
        }
        .padding(.horizontal)
    }
}

struct NewFormView_Previews: PreviewProvider {
    static var previews: some View {
        NewFormView(showNewFormView: .constant(true))
    }
}
