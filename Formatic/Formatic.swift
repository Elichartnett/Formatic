//
//  FormaticApp.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/26/22.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct Formatic: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) var scenePhase
    @StateObject var formModel = FormModel()
    @State var alertTitle = ""
    @State var showAlert = false
    
    var body: some Scene {
        WindowGroup {
            Home()
                .environment(\.managedObjectContext, DataControllerModel.shared.container.viewContext)
                .environmentObject(formModel)
                .onReceive(formModel.timer) { _ in
                    do {
                        if DataControllerModel.failed ?? false {
                            alertTitle = Strings.loadFormsErrorMessage
                            showAlert = true
                        }
                        try DataControllerModel.saveMOC()
                    }
                    catch {
                        alertTitle = Strings.saveFormErrorMessage
                        showAlert = true
                    }
                }
                .alert(alertTitle, isPresented: $showAlert, actions: {
                    Button(Strings.defaultAlertButtonDismissMessage, role: .cancel) {}
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
