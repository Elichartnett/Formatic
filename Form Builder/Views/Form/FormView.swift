//
//  FormView.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/29/22.
//

import SwiftUI

// Displays a form with title and sections
struct FormView: View {
    
    @ObservedObject var form: Form
    @State var formTitle: String = ""
    
    var body: some View {
        
        VStack {
            InputBox(placeholder: "Form title", text: $formTitle)
                .frame(width: 300)
                .onChange(of: formTitle) { _ in
                    form.title = formTitle
                }
            
            List {
                ForEach(form.sectionsArray) { section in
                    SwiftUI.Section {
                        SectionView(section: section)
                    } header: {
                        SectionTitleView(section: section)
                    }
                }
            }
        }
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView(form: dev.form)
            .environmentObject(FormModel())
    }
}
