//
//  Extension+UTType.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/26/22.
//

import Foundation
import UniformTypeIdentifiers

extension UTType: Identifiable {
    
    public var id: UUID {
        return UUID()
    }
    
    static var form: UTType {
        UTType(filenameExtension: "form")!
    }
}
