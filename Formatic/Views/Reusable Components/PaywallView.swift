//
//  PaywallView.swift
//  Formatic
//
//  Created by Eli Hartnett on 12/12/22.
//

import SwiftUI
import StoreKit

struct PaywallView: View {
    
    @Environment(\.requestReview) var requestReview
    @EnvironmentObject var formModel: FormModel
    @ObservedObject var storeKitManager: StoreKitManager
    
    @State var purchasePending = false
    @State var isLoading = false
    @State var showAlert = false
    @State var alertTitle = ""
    @State var alertButtonDismissMessage = Strings.defaultAlertButtonDismissMessage
    
    var body: some View {
        
        VStack {
            
            if storeKitManager.products.isEmpty {
                Text(Strings.failedToLoadPurchasesErrorMessage)
                Button {
                    Task {
                        isLoading = true
                        await storeKitManager.fetchProducts()
                        isLoading = true
                    }
                } label: {
                    Text(Strings.tryAgainLabel)
                }
                
            }
            else {
                Text(Strings.inAppPurchasesLabel)
                    .font(.title)
                    .bold()
                
                ForEach(FormaticProductID.allCases) { productID in
                    
                    if let product = storeKitManager.products.first(where: { product in
                        product.id == productID.rawValue
                    }) {
                        Button {
                            if !purchasePending && !storeKitManager.purchasedProducts.contains(where: { product in
                                product.id == productID.rawValue
                            }) {
                                purchasePending = true
                                Task {
                                    do {
                                        try await storeKitManager.purchase(product: product)
                                        purchasePending = false
                                        requestReview()
                                    }
                                    catch {
                                        purchasePending = false
                                        alertTitle = Strings.failedToPurchaseErrorMessage
                                        showAlert = true
                                    }
                                }
                            }
                        } label: {
                            ProductView(storeKitManager: storeKitManager, product: product, icon: getIconForProductID(productID))
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Button {
                    Task {
                        isLoading = true
                        let tempPurchasedProducts = await storeKitManager.getAllPurchases()
                        DispatchQueue.main.async {
                            storeKitManager.purchasedProducts = tempPurchasedProducts
                        }
                        isLoading = false
                        alertTitle = Strings.purchasesRestored
                        showAlert = true
                    }
                } label: {
                    Text(Strings.restorePurchasesLabel)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryBackground.ignoresSafeArea())
        .overlay {
            if isLoading || purchasePending {
                ProgressView()
            }
        }
        .alert(alertTitle, isPresented: $showAlert, actions: {
            Button(Strings.defaultAlertButtonDismissMessage, role: .cancel) {}
        })
    }
    
    func getIconForProductID(_ id: FormaticProductID) -> Image {
        switch id {
        case .lockForm:
            return Image(systemName: Constants.lockIconName)
        case .importExportFormatic:
            return Image(systemName: Constants.fileIconName)
        case .exportPdf:
            return Image(systemName: Constants.docTextImageIconName)
        case .exportCsv:
            return Image(systemName: Constants.csvTableIconName)
        }
    }
}

struct Paywall_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView(storeKitManager: dev.formModel.storeKitManager)
            .environmentObject(FormModel())
    }
}

struct ProductView: View {
    
    @ObservedObject var storeKitManager: StoreKitManager
    
    let product: Product
    let icon: Image
    
    var body: some View {
        
        let purchased = storeKitManager.purchasedProducts.contains { purchasedProduct in
            purchasedProduct.id == product.id
        }
        
        HStack {
            icon
                .customIcon(foregroundColor: .primary)
            
            VStack(alignment: .leading) {
                Text(product.displayName)
                    .font(.title3)
                Text(product.description)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if purchased {
                Image(systemName: Constants.filledCircleCheckmarkIconName)
                    .customIcon(foregroundColor: .green)
            }
            else {
                Text(product.displayPrice)
                    .foregroundColor(.blue)
            }
        }
        .frame(alignment: .leading)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.secondary)
        }
        .padding(.horizontal)
    }
}
