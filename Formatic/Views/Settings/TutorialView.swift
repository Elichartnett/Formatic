//
//  TutorialView.swift
//  Formatic
//
//  Created by Eli Hartnett on 2/5/23.
//

import SwiftUI

struct TutorialView: View {
    
    @EnvironmentObject var formModel: FormModel
    
    var tabs: [TutorialTab]
    @State var selectedTab = 0
    let didFinish: () -> ()
    
    var body: some View {
        
        VStack {
            
            TabView(selection: $selectedTab) {
                
                if tabs.contains(.intro) {
                    introView
                        .padding()
                        .tag(getIndexOfTab(tab: .intro))
                }
                
                if tabs.contains(.icons) {
                    iconsView
                        .tag(getIndexOfTab(tab: .icons))
                }
                
                if tabs.contains(.tips) {
                    tipsView
                        .tag(getIndexOfTab(tab: .tips))
                }
                
                if tabs.contains(.paywall) {
                    PaywallView(storeKitManager: formModel.storeKitManager)
                        .tag(getIndexOfTab(tab: .paywall))
                }
            }
            .tabViewStyle(.page)
            
            Button {
                withAnimation {
                    if selectedTab == tabs.count - 1 {
                        didFinish()
                    }
                    else {
                        self.selectedTab += 1
                    }
                }
            } label: {
                SubmitButton(buttonTitle: selectedTab != tabs.count - 1 ? Strings.tutorialNextLabel : Strings.tutorialCompleteLabel)
                    .padding()
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.primaryBackground)
        .toolbar(.hidden)
    }
    
    func getIndexOfTab(tab: TutorialTab) -> Int {
        tabs.firstIndex(of: tab) ?? 0
    }
    
    var introView: some View {
        VStack(spacing: 20) {
            Image(systemName: Constants.logoIconName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            Text("\(Strings.tutorialWelcomeLabel)!")
                .font(.title)
            
            Text(Strings.tutorialIntroLabel)
            
            HStack(spacing: 5) {
                Text(Strings.tutorialSkipLabel)
                Image(systemName: Constants.forwardArrowIconName).customIcon()
                    .onTapGesture {
                        withAnimation {
                            didFinish()
                        }
                    }
            }
        }
        .multilineTextAlignment(.center)
    }
    
    var iconsView: some View {
        VStack {
            Text(Strings.tutorialIconsLabel)
                .font(.title)
                .bold()
                .padding(.top)
            
            ScrollView {
                
                VStack (alignment: .leading) {
                    HStack {
                        Image(systemName: Constants.plusCircleIconName)
                            .customIcon()
                        Text(Strings.tutorialCreateLabel)
                    }
                    .padding()
                    
                    HStack {
                        Image(systemName: Constants.importFormIconName)
                            .customIcon()
                        Text(Strings.tutorialImportLabel)
                    }
                    .padding()
                    
                    HStack {
                        Image(systemName: Constants.exportFormIconName)
                            .customIcon()
                        Text(Strings.tutorialExportLabel)
                    }
                    .padding()
                    
                    HStack {
                        Image(systemName: Constants.lockIconName)
                            .customIcon()
                        Text(Strings.tutorialLockLabel)
                    }
                    .padding()
                    
                    HStack {
                        Image(systemName: Constants.sortIconName)
                            .customIcon()
                        Text(Strings.tutorialSortLabel)
                    }
                    .padding()
                    
                    HStack {
                        Image(systemName: Constants.editIconName)
                            .customIcon()
                        Text(Strings.tutorialEditLabel)
                    }
                    .padding()
                    
                    HStack {
                        Image(systemName: Constants.moveSectionIconName)
                            .customIcon()
                        Text(Strings.tutorialSectionOrderLabel)
                    }
                    .padding()
                    
                    HStack {
                        Image(systemName: Constants.moveWidgetIconName)
                            .customIcon()
                        Text(Strings.tutorialFieldOrderLabel)
                    }
                    .padding()
                    
                    HStack {
                        Image(systemName: Constants.settingsIconName)
                            .customIcon()
                        Text(Strings.settingsLabel)
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    var tipsView: some View {
        VStack {
            
            Text(Strings.tutorialTipsLabel)
                .font(.title)
                .bold()
                .padding(.top)
            
            ScrollView {
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        Image(systemName: Constants.logoIconName)
                            .customIcon()
                        Text(Strings.tutorialTip1Label)
                    }
                    .padding()
                    
                    HStack {
                        Image(systemName: Constants.exportFormIconName)
                            .customIcon()
                        Text(Strings.tutorialTip2Label)
                    }
                    .padding()
                    
                    HStack {
                        Image(systemName: Constants.editIconName)
                            .customIcon()
                        Text(Strings.tutorialTip3Label)
                    }
                    .padding()
                    
                    HStack {
                        Image(systemName: Constants.lockIconName)
                            .customIcon()
                        Text(Strings.tutorialTip4Label)
                    }
                    .padding()
                    
                    HStack {
                        Image(systemName: Constants.dollarSignIconName)
                            .customIcon()
                        Text(Strings.tutorialTip5Label)
                    }
                    .padding()
                    
                    HStack {
                        Image(systemName: Constants.supportIconName)
                            .customIcon()
                        Text(Strings.tutorialTip6Label)
                    }
                    .padding()
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TutorialView (tabs: [.intro, .icons, .tips]) {
                print("Finished")
            }
            .environmentObject(FormModel())
        }
    }
}
