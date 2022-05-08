//
//  NewFormView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

// Displays view to create new form
struct NewFormView: View {
    
    @FetchRequest(sortDescriptors: []) var forms: FetchedResults<Form>
    @Binding var showNewFormView: Bool
    @State var title: String = ""
    @State var password: String = ""
    @State var titleEmpty: Bool = true
    @State var validTitle: Bool = false
    @State var validPassword: Bool = true
    @State var isValid: Bool = false
    
    var body: some View {
        
        VStack (spacing: 20) {
            
            Text("New Form")
                .font(.title)
            
            // Form title
            InputBox(placeholder: "Title", text: $title)
                .onChange(of: title) { _ in
                    withAnimation {
                        if title.isEmpty {
                            titleEmpty = true
                        }
                        else {
                            titleEmpty = false
                        }
                        
                        if forms.contains(where: { form in
                            form.title == title
                        }) {
                            validTitle = false
                        }
                        else {
                            validTitle = true
                        }
                        if !titleEmpty && validTitle {
                            isValid = true
                        }
                    }
                }
            
            
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
                    if !password.isEmpty {
                        form.password = password
                        form.locked = true
                    }
                    DataController.saveMOC()
                }
                showNewFormView = false
                
            } label: {
                SubmitButton(isValid: $isValid)
            }
            .disabled(!(validTitle && validPassword))
            
            if !validTitle && !titleEmpty {
                Text("Title already in use")
                    .foregroundColor(.red)
            }
            if !validPassword {
                Text("Passwords do not match")
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
