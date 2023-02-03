//
//  ListViewToolbar.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/29/22.
//

import SwiftUI

struct ListViewToolbar: View {
    
    @EnvironmentObject var formModel: FormModel
    
    @Binding var showNewFormView: Bool
    let showSortMethodMenu: Bool
    @Binding var sortMethod: SortMethod
    @Binding var showImportFormView: Bool
    @Binding var showSettingsMenu: Bool
    @State var showPaywallView = false
    
    var body: some View {
        
        HStack {
            
            Spacer()
            
            Button {
                showNewFormView = true
            } label: {
                HStack {
                    Image(systemName: Constants.plusCircleIconName)
                        .customIcon()
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
                                    .customIcon(foregroundColor: .primary)
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
                                .customIcon(foregroundColor: .primary)
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: Constants.sortIconName)
                            .customIcon()
                        if !formModel.isPhone {
                            Text(Strings.sortLabel)
                        }
                    }
                }
                
                Spacer()
            }
            
            EditModeButton(onTap: {})
            
            Spacer()
            
            Button {
                if formModel.storeKitManager.purchasedProducts.contains(where: { product in
                    product.id == FormaticProductID.importExportFormatic.rawValue
                }) {
                    showImportFormView = true
                }
                else {
                    showPaywallView = true
                }
            } label: {
                HStack {
                    Image(systemName: Constants.importFormIconName)
                        .customIcon()
                    if !formModel.isPhone {
                        Text(Strings.importLabel)
                    }
                }
                .accessibilityLabel(Strings.importLabel)
            }
            
            Spacer()
            
            Button {
                showSettingsMenu = true
            } label: {
                HStack {
                    Image(systemName: Constants.settingsIconName)
                        .customIcon()
                    if !formModel.isPhone {
                        Text(Strings.settingsLabel)
                    }
                }
                .accessibilityLabel(Strings.settingsLabel)
            }
            
            Spacer()
        }
        .sheet(isPresented: $showPaywallView) {
            PaywallView(storeKitManager: formModel.storeKitManager)
        }
    }
}

struct ListViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        ListViewToolbar(showNewFormView: .constant(false), showSortMethodMenu: true, sortMethod: .constant(.dateCreated), showImportFormView: .constant(false), showSettingsMenu: .constant(false))
            .environmentObject(FormModel())
    }
}
