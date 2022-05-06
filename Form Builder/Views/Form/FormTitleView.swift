//
//  FormTitleView.swift
//  Form Builder
//
//  Created by Eli Hartnett on 5/4/22.
//

import SwiftUI

struct FormTitleView: View {
    
    @State var form: Form
    @State var formTitle: String = ""
    
    var body: some View {
        
        VStack {
            TextField("Form title", text: $formTitle)
                .font(Font.largeTitle.weight(.bold))
                .onAppear {
                    formTitle = form.title ?? ""
                }
                .onChange(of: formTitle) { newValue in
                    form.title = formTitle
            }
            
            Rectangle()
                .frame(height: 1)
        }
    }
}

struct FormTitleView_Previews: PreviewProvider {
    static var previews: some View {
        FormTitleView(form: dev.form)
    }
}
