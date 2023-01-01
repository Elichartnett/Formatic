//
//  PaywallView.swift
//  Formatic
//
//  Created by Eli Hartnett on 12/12/22.
//

import SwiftUI
import StoreKit

struct PaywallView: View {
    
    @EnvironmentObject var formModel: FormModel
    
    @State var showAlert = false
    @State var alertTitle = ""
    @State var alertButtonDismissMessage = Strings.defaultAlertButtonDismissMessage
    
    var body: some View {
        
        VStack {
            
            Text(Strings.inAppPurchasesLabel)
                .font(.title)
                .bold()
            
            ForEach(FormaticProductID.allCases) { productID in
                
                if let product = formModel.storeKitManager.products.first(where: { product in
                    product.id == productID.rawValue
                }) {
                    Button {
                        Task {
                            do {
                                try formModel.storeKitManager.purchase(product: product)
                            }
                            catch {
                                alertTitle = Strings.failedToPurchaseErrorMessage
                                showAlert = true
                            }
                        }
                    } label: {
                        ProductView(storeKitManager: formModel.storeKitManager, product: product, icon: getIconForProductID(productID))
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Button {
                Task {
                    let tempPurchasedProducts = await formModel.storeKitManager.getAllPurchases()
                    DispatchQueue.main.async {
                        formModel.storeKitManager.purchasedProducts = tempPurchasedProducts
                    }
                    alertTitle = Strings.purchasesRestored
                    showAlert = true
                }
            } label: {
                Text(Strings.restorePurchasesLabel)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryBackground.ignoresSafeArea())
        .alert(alertTitle, isPresented: $showAlert, actions: {
            Button(Strings.defaultAlertButtonDismissMessage, role: .cancel) {}
        })
    }
    
    func getIconForProductID(_ id: FormaticProductID) -> Image {
        switch id {
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
        PaywallView()
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
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
            Text(product.displayName)
            
            Spacer()
            
            if purchased {
                Image(systemName: Constants.filledCircleCheckmarkIconName)
                    .foregroundColor(.green)
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
