//
//  FormaticApp.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/26/22.
//

import SwiftUI
import Firebase
import StoreKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        
        return true
    }
}

@main
struct Formatic: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var formModel = FormModel()
    @State var alertTitle = Constants.emptyString
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
                .onAppear {
                    let _ = TransactionObserver(storeKitManager: formModel.storeKitManager)
                }
                .onChange(of: formModel.storeKitManager.errorMessage) { errorMessage in
                    if !errorMessage.isEmpty {
                        alertTitle = errorMessage
                        showAlert = true
                    }
                }
        }
    }
}

final class TransactionObserver {
    
    let storeKitManager: StoreKitManager
    var updates: Task<Void, Never>? = nil
    
    init(storeKitManager: StoreKitManager) {
        self.storeKitManager = storeKitManager
        
        Task.detached {
            for await result in Transaction.updates {
                switch result {
                case .unverified(_, _):
                    break
                case .verified(_):
                    let tempPurchasedProducts = await self.storeKitManager.updatePurchasedProducts()
                    self.storeKitManager.purchasedProducts.removeAll()
                    self.storeKitManager.purchasedProducts = tempPurchasedProducts
                }
            }
        }
    }

    deinit {
        // Cancel the update handling task when you deinitialize the class.
        updates?.cancel()
    }
}
