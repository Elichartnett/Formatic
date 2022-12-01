//
//  Protocols.swift
//  Formatic
//
//  Created by Tanner Hess on 9/6/22.
//

import Foundation


protocol Csv {
    
    func toCsv() -> String
}

protocol Copyable {
    
    func createCopy() -> Any
}
