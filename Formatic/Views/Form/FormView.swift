//
//  FormView.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/29/22.
//

import SwiftUI

// Displays a form with title and sections
struct FormView: View {
    
    @ObservedObject var form: Form
    @State var formTitle: String = ""
    
    var body: some View {
        
        VStack (spacing: 0) {
            
            FormTitleView(form: form)
                .padding(.horizontal)
                .background(
                    Color(uiColor: .systemGray6)
                )
            
            List {
                
                ForEach(form.sections?.sorted(by: { lhs, rhs in
                    lhs.position < rhs.position
                }) ?? []) { section in
                    SwiftUI.Section {
                        SectionView(section: section, locked: $form.locked)
                    } header: {
                        SectionTitleView(section: section, locked: $form.locked)
                    }
                    .headerProminence(.increased)
                }
            }
            .onDisappear {
                DataController.saveMOC()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FormView(form: dev.form)
                .environmentObject(FormModel())
        }
        .navigationViewStyle(.stack)
    }
}
