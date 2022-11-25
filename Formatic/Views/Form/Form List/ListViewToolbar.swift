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
    @Binding var showSettingsMenu: Bool
    
    var body: some View {
        
        HStack {
            
            Spacer()
            
            // Create new form button
            Button {
                showNewFormView = true
            } label: {
                
                HStack {
                    Image(systemName: Strings.plusCircleIconName)
                    if !formModel.isPhone {
                        Text(Strings.newFormLabel)
                    }
                }
            }
            
            Spacer()
            
            // Sort method menu
            if showSortMethodMenu {
                
                Menu {
                    Button {
                        sortMethod = .dateCreated
                    } label: {
                        HStack {
                            Text(Strings.dateCreatedLabel)
                            
                            Spacer()
                            
                            if sortMethod == .dateCreated {
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
                    HStack {
                        Image(systemName: Strings.sortIconName)
                        if !formModel.isPhone {
                            Text(Strings.sortMethodLabel)
                        }
                    }
                }
                
                Spacer()
            }
                        
            // Edit Mode button
            EditModeButton(onTap: {})
            
            Spacer()
            
            // Import form button
            Button {
                showImportFormView = true
            } label: {
                HStack {
                    Image(systemName: Strings.importFormIconName)
                    if !formModel.isPhone {
                        Text(Strings.importLabel)
                    }
                }
            }
            
            Spacer()
            
            Group {
                Button {
                    showSettingsMenu = true
                } label: {
                    HStack {
                        Image(systemName: Strings.settingsIconName)
                        if !formModel.isPhone {
                            Text(Strings.settingsLabel)
                        }
                    }
                }
                
                Spacer()
            }
        }
    }
}

struct ListViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        let showSortMethodButton = (try? !dev.formModel.getForms().isEmpty) ?? false
        ListViewToolbar(showNewFormView: .constant(false), showImportFormView: .constant(false), showSortMethodMenu: showSortMethodButton, sortMethod: .constant(.dateCreated), showSettingsMenu: .constant(false))
            .environmentObject(FormModel())
    }
}
