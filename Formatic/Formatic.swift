//
//  FormaticApp.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/26/22.
//

import SwiftUI

@main
struct Formatic: App {
    
    @Environment(\.scenePhase) var scenePhase
    @State var viewContext = DataControllerModel.shared.container.viewContext
    @StateObject var formModel = FormModel()
    @State var alertTitle = ""
    @State var showAlert = false
    @State var alertButtonTitle = "Okay"
    
    var body: some Scene {
        WindowGroup {
            Home()
                .environment(\.managedObjectContext, viewContext)
                .environmentObject(formModel)
                .onReceive(formModel.timer) { _ in
                    do {
                        if viewContext.hasChanges { try DataControllerModel.saveMOC() }
                    }
                    catch {
                        alertTitle = "Error saving form"
                        showAlert = true
                    }
                }
                .alert(alertTitle, isPresented: $showAlert, actions: {
                    Button(alertButtonTitle, role: .cancel) {}
                })
        }
    }
}
