//
//  StoreKitManager.swift
//  Formatic
//
//  Created by Eli Hartnett on 12/12/22.
//

import Foundation
import StoreKit
import SwiftUI

class StoreKitManager: ObservableObject {
    
    @Published var products: [Product] = []
    @Published var purchasedProducts: [Product] = []
    
    init() {
        Task {
            await fetchProducts()
            purchasedProducts = await updatePurchasedProducts()
        }
    }
    
    func fetchProducts() async {
        var productIDs: [String] = []
        FormaticProductID.allCases.forEach { product in
            productIDs.append(product.rawValue)
        }
        do {
            products = try await Product.products(for: productIDs)
        }
        catch {
            print(error)
        }
    }
    
    func updatePurchasedProducts() async -> [Product] {
        var tempPurchasedProducts = [Product]()
        for product in products {
            if await isPurchased(product: product) {
                tempPurchasedProducts.append(product)
            }
        }
        
        if tempPurchasedProducts.contains(where: { product in
            product.id == FormaticProductID.importExportFormatic.rawValue ||
            product.id == FormaticProductID.exportPdf.rawValue ||
            product.id == FormaticProductID.exportCsv.rawValue ||
            product.id == FormaticProductID.lockForm.rawValue
        }) {
            if !tempPurchasedProducts.contains(where: { product in
                product.id == FormaticProductID.pro.rawValue
            }) {
                if let pro = products.first { $0.id == FormaticProductID.pro.rawValue } {
                    tempPurchasedProducts.append(pro)
                }
                else {
                    print("Error")
                }
            }
        }
        
        return tempPurchasedProducts
    }
    
    func purchase(product: Product) async throws -> Bool {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            switch verification {
            case .unverified(_, _):
                return false
            case .verified(_):
                DispatchQueue.main.async { [weak self] in
                    self?.purchasedProducts.append(product)
                }
                return true
            }
        case .userCancelled, .pending:
            return false
        default:
            return false
        }
    }
    
    func isPurchased(product: Product) async -> Bool {
        guard let state = await product.currentEntitlement else { return false }
        switch state {
        case .unverified(_, _):
            return false
        case .verified(_):
            return true
        }
    }
}
