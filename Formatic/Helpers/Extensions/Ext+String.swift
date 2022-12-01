//
//  Extension+String.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/26/22.
//

import Foundation

extension String {
    
    func isValidNumber(range: ClosedRange<Double>? = nil) -> Bool {
        if let number = Double(self) {
            if let range = range {
                if number >= range.lowerBound && number <= range.upperBound {
                    return true
                }
                else {
                    return false
                }
            }
            else {
                return true
            }
        }
        else {
            if self == "-" {
                return true
            }
            return false
        }
    }
    
    mutating func enforceNumberValidation() {
        self.removeAll { character in
            !character.isNumber && character != "-" && character != "."
        }
                                
        var decimalUsed = false
        for (index, character) in self.enumerated() {
            if character == "-" && index != 0 {
                self.remove(at: self.index(self.startIndex, offsetBy: index))
            }
            else if character == "." {
                if !decimalUsed {
                    decimalUsed = true
                }
                else {
                    self.remove(at: self.index(self.startIndex, offsetBy: index))
                }
            }
        }
    }
}
