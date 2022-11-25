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
            InputBox(placeholder: Strings.optionalFormPasswordLabel, text: $password, inputType: .password)
                .onChange(of: password) { _ in
                    withAnimation {
                        if password.isEmpty {
                            validPassword = true
                            showPasswordConfirmation = false
                        }
                        else {
                            validPassword = false
                            showPasswordConfirmation = true
                        }
                    }
                }
            
            // Confirm password if optional password is used on form
            if showPasswordConfirmation {
                InputBox(placeholder: Strings.retypeFormPasswordLabel, text: $passwordConfirmation, inputType: .password)
                    .onChange(of: passwordConfirmation) { _ in
                        withAnimation {
                            if passwordConfirmation == password && !password.isEmpty {
                                validPassword = true
                            }
                            else {
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
