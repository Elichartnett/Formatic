//
//  TutorialView.swift
//  Formatic
//
//  Created by Eli Hartnett on 2/5/23.
//

import SwiftUI

struct TutorialView: View {
    
    @EnvironmentObject var formModel: FormModel
    
    @State var selectedTab = 0
    var showIntro = false
    let didFinish: () -> ()
    
    var body: some View {
        
#warning("localize and abstract")
#warning("remove outtro while viewing tutorial from settings")
        
        VStack {
            
            TabView(selection: $selectedTab) {
                
                if showIntro {
                    VStack(spacing: 20) {
                        Image(systemName: Constants.logoIconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                        Text("Welcome to Formatic!")
                            .font(.title)
                        
                        Text("Please take a few moments to learn more about the app to enhance your experience.")
                        
                        Button {
                            withAnimation {
                                didFinish()
                            }
                        } label: {
                            Text("This tutorial will always be available in settings. To skip ahead, click here ") + Text(Image(systemName: "arrow.forward"))
                        }
                    }
                    .multilineTextAlignment(.center)
                    .padding()
                    .tag(0)
                }
                
                VStack {
                    Text("Icons")
                        .font(.title)
                        .bold()
                        .padding(.top)
                    
                    ScrollView {
                        
                        VStack (alignment: .leading) {
                            HStack {
                                Image(systemName: Constants.plusCircleIconName)
                                    .customIcon()
                                Text("Create a new form, section, or field")
                            }
                            .padding()
                            
                            HStack {
                                Image(systemName: Constants.importFormIconName)
                                    .customIcon()
                                Text("Import a form")
                            }
                            .padding()
                            
                            HStack {
                                Image(systemName: Constants.exportFormIconName)
                                    .customIcon()
                                Text("Export a form")
                            }
                            .padding()
                            
                            HStack {
                                Image(systemName: Constants.lockIconName)
                                    .customIcon()
                                Text("Lock or unlock a form")
                            }
                            .padding()
                            
                            HStack {
                                Image(systemName: Constants.sortIconName)
                                    .customIcon()
                                Text("Sort forms")
                            }
                            .padding()
                            
                            HStack {
                                Image(systemName: Constants.editIconName)
                                    .customIcon()
                                Text("Toggle edit mode")
                            }
                            .padding()
                            
                            HStack {
                                Image(systemName: Constants.moveSectionIconName)
                                    .customIcon()
                                Text("Change order of sections")
                            }
                            .padding()
                            
                            HStack {
                                Image(systemName: Constants.moveWidgetIconName)
                                    .customIcon()
                                Text("Change order of fields")
                            }
                            .padding()
                            
                            HStack {
                                Image(systemName: Constants.settingsIconName)
                                    .customIcon()
                                Text("Settings")
                            }
                            .padding()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                }
                .tag(1)
                
                VStack {
                    Text("Tips")
                        .font(.title)
                        .bold()
                        .padding(.top)
                    
                    ScrollView {
                        
                        VStack(alignment: .leading) {
                            
                            Group {
                                
                            }
                            
                            HStack {
                                Image(systemName: Constants.logoIconName)
                                    .customIcon()
                                Text("Forms are made up of sections and sections are made up of fields.")
                            }
                            .padding()
                            
                            HStack {
                                Image(systemName: Constants.exportFormIconName)
                                    .customIcon()
                                Text("Forms can be export as a .form, .pdf, or .csv. For easy reuse, consider creating a template and either saving it as a .form file or making multiple copies.")
                            }
                            .padding()
                            
                            HStack {
                                EditModeButton { }
                                    .disabled(true)
                                Text("Edit mode enables the selection of multiple forms for copying, deleting, or exporting. Enabling edit mode while inside of a form enables moving sections or selecting multiple fields inside of a section for copying, deleting, or moving. Additionally, fields that require configuration upon creation can also be reconfigured with edit mode.")
                            }
                            .padding()
                            
                            HStack {
                                Image(systemName: Constants.lockIconName)
                                    .customIcon()
                                Text("Adding a lock to a form restricts all form customization while still allowing for fields to be filled out. After setting up, locks can be temporarily disabled or removed completely.")
                            }
                            .padding()
                            
                            HStack {
                                Image(systemName: Constants.supportIconName)
                                    .customIcon()
                                Text("If you encounter any issues or have any suggestions, navigation to settings and click submit feedback.")
                            }
                            .padding()
                            
                            HStack {
                                Image(systemName: "dollarsign.circle")
                                    .customIcon()
                                Text("In app purchases are optional, but will give lifetime access to premium features.")
                            }
                            .padding()
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .tag(2)
                
                PaywallView(storeKitManager: formModel.storeKitManager)
                    .tag(3)
            }
            .tabViewStyle(.page)
            
            Button {
                withAnimation {
                    if selectedTab == 3 {
                        didFinish()
                    }
                    else {
                        selectedTab += 1
                    }
                }
            } label: {
                SubmitButton(buttonTitle: selectedTab != 3 ? "Next" : "Complete")
                    .padding()
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.primaryBackground)
        .toolbar(.hidden)
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TutorialView {
                print("Finished")
            }
                .environmentObject(FormModel())
        }
    }
}
