//
//  ToggleLockView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/6/22.
//

import SwiftUI
import FirebaseAnalytics

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
                InputBox(placeholder: Strings.passwordLabel, text: $enteredPassword, inputType: .password)
                    .onChange(of: enteredPassword) { _ in
                        validPassword = (enteredPassword == form.password)
                    }
            }
            else {
                PasswordView(validPassword: $validPassword, password: $enteredPassword)
            }
            
            VStack {
                if form.password != nil {
                    Toggle(Strings.removeLockLabel, isOn: $removePassword)
                        .labelStyle(.titleAndIcon)
                }
                Button {
                    if form.password == nil {
                        form.password = enteredPassword
                        form.locked = true
                        Analytics.logEvent(Constants.analyticsCreateLockFormEvent, parameters: nil)
                    }
                    else {
                        form.locked = false
                        if removePassword {
                            form.password = nil
                            Analytics.logEvent(Constants.analyticsRemoveLockFormEvent, parameters: nil)
                        }
                        Analytics.logEvent(Constants.analyticsUnlockFormEvent, parameters: nil)
                    }
                    showToggleLockView = false
                } label: {
                    SubmitButton()
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