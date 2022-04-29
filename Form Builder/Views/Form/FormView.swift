//
//  FormView.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/29/22.
//

import SwiftUI

struct FormView: View {
    
    @State var form: Form
    
    var body: some View {
        
        VStack {
            Text(form.title)
            
            ForEach(form.sectionsArray) { section in
                SectionView(section: section)
            }
        }
        
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView(form: dev.form)
    }
}
