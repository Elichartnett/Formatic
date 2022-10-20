//
//  ListViewToolbar.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/29/22.
//

import SwiftUI

// Tool bar options for list of saved forms
struct ListViewToolbar: View {
    
    @Binding var showNewFormView: Bool
    @Binding var showImportFormView: Bool
    @State var showSortMethodMenu: Bool
    @Binding var sortMethod: SortMethod
    
    var body: some View {
        
        HStack {
            
            Spacer()
            
            // Create new form button
            Button {
                showNewFormView = true
            } label: {
                HStack {
                    Image(systemName: Strings.plusCircleIconName)
                    Text(Strings.newFormLabel)
                }
            }
            
            Spacer()
            
            // Import form button
            Button {
                showImportFormView = true
            } label: {
                HStack {
                    Image(systemName: Strings.importFormIconName)
                    Text(Strings.importLabel)
                }
            }
            
            Spacer()
            
            if showSortMethodMenu {
                
                Menu {
                    Button(Strings.defaultLabel) {
                        sortMethod = .defaultOrder
                    }
                    Button(Strings.alphabeticalyLabel) {
                        sortMethod = .alphabetical
                    }
                } label: {
                    Image(systemName: Strings.sortIconName)
                }
                
                Spacer()
            }
        }
    }
}

struct ListViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        let showSortMethodButton = (try? !dev.formModel.getForms().isEmpty) ?? false
        ListViewToolbar(showNewFormView: .constant(false), showImportFormView: .constant(false), showSortMethodMenu: showSortMethodButton, sortMethod: .constant(.defaultOrder))
    }
}
