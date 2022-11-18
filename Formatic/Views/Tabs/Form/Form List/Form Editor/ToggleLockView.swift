//
//  ToggleLockView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/6/22.
//

import SwiftUI

// View used in sheet to unlock or set up lock - not displayed to lock
struct ToggleLockView: View {
    
    @Binding var showToggleLockView: Bool
    @State var form: Form
    @State var enteredPassword = ""
    @State var validPassword = false
    @State var removePassword = false
    
    var body: some View {
        
        VStack {
            
            Text(form.password != nil ? Strings.unlockLabel : Strings.setupLockLabel)
                .font(.title)
                .bold()
            
            if form.password != nil {
                // Unlock
                InputBox(placeholder: Strings.passwordLabel, text: $enteredPassword, inputType: .password)
                    .onChange(of: enteredPassword) { _ in
                        validPassword = (enteredPassword == form.password)
                    }
            }
            else {
                // Set up lock
                PasswordView(validPassword: $validPassword, password: $enteredPassword)
            }
            
            VStack {
                if form.password != nil {
                    Toggle(Strings.removeLockLabel, isOn: $removePassword)
                        .labelStyle(.titleAndIcon)
                }
                Button {
                    // Set up new password
                    if form.password == nil {
                        form.password = enteredPassword
                        form.locked = true
                    }
                    // Unlock form
                    else {
                        form.locked = false
                        if removePassword {
                            form.password = nil
                        }
                    }
                    showToggleLockView = false
                } label: {
                    SubmitButton(isValid: $validPassword)
                }
                .disabled(!validPassword)
            }
        }
        .padding(.horizontal)
    }
}

struct ToggleLockView_Previews: PreviewProvider {
    static var previews: some View {
        ToggleLockView(showToggleLockView: .constant(true), form: dev.form)
    }
}
