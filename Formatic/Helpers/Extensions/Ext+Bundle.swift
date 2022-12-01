//
//  Extension+Bundle.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/26/22.
//

import Foundation

extension Bundle {
    
    var shortVersion: String {
        if let result = infoDictionary?["CFBundleShortVersionString"] as? String {
            return result
        } else {
            assert(false)
            return ""
        }
    }
    
    var buildVersion: String {
        if let result = infoDictionary?["CFBundleVersion"] as? String {
            return result
        } else {
            assert(false)
            return ""
        }
    }
    
    var fullVersion: String { "\(shortVersion) (\(buildVersion))" }
}
