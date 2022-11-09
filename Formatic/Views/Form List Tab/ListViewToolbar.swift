//
//  ListViewToolbar.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/29/22.
//

import SwiftUI

// Tool bar options for list of saved forms
struct ListViewToolbar: View {
    
    @EnvironmentObject var formModel: FormModel
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
                if formModel.isPhone {
                    Image(systemName: Strings.plusCircleIconName)
                }
                else {
                    HStack {
                        Image(systemName: Strings.plusCircleIconName)
                        Text(Strings.newFormLabel)
                    }
                }
            }
            
            Spacer()
            
            // Import form button
            Button {
                showImportFormView = true
            } label: {
                if formModel.isPhone {
                    Image(systemName: Strings.importFormIconName)
                }
                else {
                    HStack {
                        Image(systemName: Strings.importFormIconName)
                        Text(Strings.importLabel)
                    }
                }
            }
            
            Spacer()
            
            // Sort method menu
            if showSortMethodMenu {
                
                Menu {
                    Button {
                        sortMethod = .defaultOrder
                    } label: {
                        HStack {
                            Text(Strings.defaultLabel)
                            
                            Spacer()
                            
                            if sortMethod == .defaultOrder {
                                Image(systemName: Strings.checkmarkIconName)
                                    .customIcon()
                            }
                        }
                    }
                    
                    Button {
                        sortMethod = .alphabetical
                    } label: {
                        Text(Strings.alphabeticalyLabel)
                        
                        Spacer()
                        
                        if sortMethod == .alphabetical {
                            Image(systemName: Strings.checkmarkIconName)
                                .customIcon()
                        }
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
