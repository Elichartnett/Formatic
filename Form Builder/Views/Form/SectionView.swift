//
//  SectionView.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/29/22.
//

import SwiftUI

struct SectionView: View {
    
    @State var section: Section
    
    var body: some View {
        
        VStack {
            ForEach(section.widgetsArray) { widget in
                if widget is TextFieldWidget {
                    Text("text field widget")
                }
                else {
                    Text("not text field widget")
                }
            }
        }
    }
}

struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionView(section: Section(title: "Section title"))
    }
}
