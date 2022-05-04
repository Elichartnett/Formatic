//
//  FormModel.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/28/22.
//

import Foundation
import SwiftUI

class FormModel: ObservableObject {
    func validNumber(number: String, range: ClosedRange<Double>?) -> Bool {
        // Check if field only contains nubmers
        if let number = Double(number) {
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
        // Not a valid number
        else {
            return false
        }
    }
}
