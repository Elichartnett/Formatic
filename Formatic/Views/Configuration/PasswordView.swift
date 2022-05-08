//
//  PasswordView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/6/22.
//

import SwiftUI

struct PasswordView: View {
    
    @Binding var validPassword: Bool
    @Binding var password: String
    @State var showPasswordConfirmation: Bool = false
    @State var passwordConfirmation: String = ""
    
    var body: some View {
        
        VStack {
            
            // Optional form password
            InputBox(placeholder: "Optional password", text: $password, inputType: .password)
                .onChange(of: password) { _ in
                    if !password.isEmpty {
                        withAnimation {
                            validPassword = false
                            showPasswordConfirmation = true
                        }
                    }
                    else {
                        withAnimation {
                            validPassword = true
                            showPasswordConfirmation = false
                            passwordConfirmation = ""
                        }
                    }
                }
            
            // Confirm password if optional password is used on form
            if showPasswordConfirmation {
                InputBox(placeholder: "Retype password", text: $passwordConfirmation, inputType: .password)
                    .onChange(of: passwordConfirmation) { _ in
                        if passwordConfirmation == password {
                            withAnimation {
                                validPassword = true
                            }
                        }
                        else {
                            withAnimation {
                                validPassword = false
                            }
                        }
                    }
            }
        }
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView(validPassword: .constant(true), password: .constant(""))
    }
}
