//
//  Form_BuilderApp.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/26/22.
//

import SwiftUI

@main
struct Form_Builder: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            Home()
                .environment(\.managedObjectContext, DataController.shared.container.viewContext)
                .environmentObject(FormModel())
                .onChange(of: scenePhase) { newPhase in
                    switch newPhase {
                        
                    case .background:
                        DataController.saveMOC()
                    case .inactive:
                        break
                    case .active:
                        break
                    @unknown default:
                        break
                    }
                }
        }
    }
}
