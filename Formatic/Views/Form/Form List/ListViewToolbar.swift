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
    @State var showSortMethodMenu: Bool
    @Binding var sortMethod: SortMethod
    @Binding var showImportFormView: Bool
    @Binding var showSettingsMenu: Bool
    
    var body: some View {
        
        HStack {
            
            Spacer()
            
            Button {
                showNewFormView = true
            } label: {
                
                HStack {
                    Image(systemName: Constants.plusCircleIconName)
                    if !formModel.isPhone {
                        Text(Strings.newFormLabel)
                    }
                }
            }
            
            Spacer()
            
            if showSortMethodMenu {
                
                Menu {
                    Button {
                        sortMethod = .dateCreated
                    } label: {
                        HStack {
                            Text(Strings.dateCreatedLabel)
                            
                            Spacer()
                            
                            if sortMethod == .dateCreated {
                                Image(systemName: Constants.checkmarkIconName)
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
                            Image(systemName: Constants.checkmarkIconName)
                                .customIcon()
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: Constants.sortIconName)
                        if !formModel.isPhone {
                            Text(Strings.sortMethodLabel)
                        }
                    }
                }
                
                Spacer()
            }
            
            EditModeButton(onTap: {})
            
            Spacer()
            
            Button {
                showImportFormView = true
            } label: {
                HStack {
                    Image(systemName: Constants.importFormIconName)
                    if !formModel.isPhone {
                        Text(Strings.importLabel)
                    }
                }
            }
            
            Spacer()
            
            Button {
                showSettingsMenu = true
            } label: {
                HStack {
                    Image(systemName: Constants.settingsIconName)
                    if !formModel.isPhone {
                        Text(Strings.settingsLabel)
                    }
                }
            }
            
            Spacer()
        }
    }
}

struct ListViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        ListViewToolbar(showNewFormView: .constant(false), showSortMethodMenu: false, sortMethod: .constant(.dateCreated), showImportFormView: .constant(false), showSettingsMenu: .constant(false))
            .environmentObject(FormModel())
    }
}
