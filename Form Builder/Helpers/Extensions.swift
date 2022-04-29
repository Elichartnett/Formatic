//
//  Extensions.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/29/22.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    private init() {}
    
    let form = Form(title: "Form Title")
}
