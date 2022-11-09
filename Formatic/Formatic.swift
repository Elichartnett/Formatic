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
    @State var alertButtonDismissMessage = Strings.defaultAlertButtonDismissMessage
    
    var body: some Scene {
        WindowGroup {
            Home()
                .environment(\.managedObjectContext, viewContext)
                .environmentObject(formModel)
                .onReceive(formModel.timer) { _ in
                    do {
                        if DataControllerModel.failed ?? false {
                            alertTitle = Strings.loadFormsErrorMessage
                            showAlert = true
                        }
                        if viewContext.hasChanges { try DataControllerModel.saveMOC() }
                    }
                    catch {
                        alertTitle = Strings.saveFormErrorMessage
                        showAlert = true
                    }
                }
                .alert(alertTitle, isPresented: $showAlert, actions: {
                    Button(alertButtonDismissMessage, role: .cancel) {}
                })
                .overlay {
                    GeometryReader { proxy in
                        EmptyView()
                            .onChange(of: proxy.size.width) { newValue in
                                if newValue < CGFloat(654.0) {
                                    formModel.isPhone = true
                                }
                                else {
                                    formModel.isPhone = false

                                }
                            }
                    }
                }
        }
    }
}
