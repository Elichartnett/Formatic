//
//  Extension+URL.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/26/22.
//

import Foundation

extension URL {
    
    func toData() throws -> Data {
        do {
            _ = self.startAccessingSecurityScopedResource()
            let data = try Data(contentsOf: self)
            self.stopAccessingSecurityScopedResource()
            return data
        }
        catch {
            throw FormError.urlToDataError
        }
    }
}
