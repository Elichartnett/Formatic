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
        
        List {
            
            SwiftUI.Section {
                EmptyView()
            } header: {
                FormTitleView(form: form)
            }
            .textCase(.none)
            .headerProminence(.increased)
            
            ForEach(form.sectionsArray) { section in
                SwiftUI.Section {
                    SectionView(section: section, locked: $form.locked)
                        .onChange(of: section) { newValue in
                            print("changed")
                        }
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
