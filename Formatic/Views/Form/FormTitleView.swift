//
//  FormTitleView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/4/22.
//

import SwiftUI

struct FormTitleView: View {
    
    @ObservedObject var form: Form
    @State var formTitle: String = ""
    @FocusState var formTitleIsFocused: Bool
    @State var lastValidTitle: String = ""
    @State var showAlert: Bool = false
    @State var alertTitle: String = ""
    @State var alertMessage: String = "Okay"
    
    var body: some View {
        
        VStack {
            
            TextField("Form title", text: $formTitle)
                .font(.largeTitle.weight(.bold))
                .focused($formTitleIsFocused)
                .onAppear {
                    formTitle = form.title ?? ""
                    lastValidTitle = formTitle
                }
                .onChange(of: formTitle) { _ in
                    if !formTitle.isEmpty {
                        form.title = formTitle
                        lastValidTitle = formTitle
                    }
                }
                .onChange(of: formTitleIsFocused) { _ in
                    if !formTitleIsFocused && formTitle.isEmpty {
                        alertTitle = "Title can not be empty"
                        showAlert = true
                        formTitle = lastValidTitle
                    }
                }
            
            Rectangle()
                .frame(height: 1)
        }
        .disabled(form.locked)
        .alert(alertTitle, isPresented: $showAlert, actions: {
            Button(alertMessage, role: .cancel) {}
        })
    }
}

struct FormTitleView_Previews: PreviewProvider {
    static var previews: some View {
        FormTitleView(form: dev.form)
    }
}
