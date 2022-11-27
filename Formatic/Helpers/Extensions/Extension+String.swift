//
//  Extension+String.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/26/22.
//

import Foundation

extension String {
    func isValidNumber(range: ClosedRange<Double>? = nil) -> Bool {
        // Check if field only contains nubmers
        if let number = Double(self) {
            // Check if number is in range
            if let range = range {
                if number >= range.lowerBound && number <= range.upperBound {
                    return true
                }
                else {
                    return false
                }
            }
            // Number is valid, but there is no range
            else {
                return true
            }
        }
        else {
            // Have only typed negative sign
            if self == "-" {
                return true
            }
            // Not a valid number
            return false
        }
    }
}
