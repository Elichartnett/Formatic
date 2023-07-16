//
//  FormTitleView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/4/22.
//

import SwiftUI

struct FormTitleView: View {
    
    @ObservedObject var form: Form
    @State var formTitle: String
    @FocusState var formTitleIsFocused: Bool
    @State var showAlert = false
    @State var alertTitle = Constants.emptyString
    
    init(form: Form, formTitle: String?) {
        self.form = form
        self.formTitle = formTitle ?? Constants.emptyString
    }
    
    var body: some View {
        
        VStack {
            
            TextField(Strings.formTitleLabel, text: $formTitle)
                .font(.largeTitle)
                .bold()
                .focused($formTitleIsFocused)
                .onAppear {
                    formTitle = form.title ?? Constants.emptyString
                }
                .onChange(of: formTitle) { _ in
                    form.title = formTitle
                }
            
            Rectangle()
                .frame(height: 1)
        }
        .disabled(form.locked)
        .alert(alertTitle, isPresented: $showAlert, actions: {
            Button(Strings.defaultAlertButtonDismissMessage, role: .cancel) {}
        })
    }
}

struct FormTitleView_Previews: PreviewProvider {
    static var previews: some View {
        FormTitleView(form: dev.form, formTitle: dev.form.title)
    }
}
