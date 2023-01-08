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
            await updatePurchasedProducts()
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
    
    func updatePurchasedProducts() async {
        
    }
    
    func purchase(product: Product) async throws {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            switch verification {
            case .unverified(_, _):
                break
            case .verified(_):
                DispatchQueue.main.async { [weak self] in
                    self?.purchasedProducts.append(product)
                }
            }
        case .userCancelled, .pending:
            break
        default:
            break
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
    
    func getAllPurchases() async -> [Product] {
        var tempPurchasedProducts = [Product]()
        for product in products {
            if await isPurchased(product: product) {
                tempPurchasedProducts.append(product)
            }
        }
        return tempPurchasedProducts
    }
}
