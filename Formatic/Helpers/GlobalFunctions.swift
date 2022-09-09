//
//  GlobalFunctions.swift
//  Formatic
//
//  Created by Tanner Hess on 9/7/22.
//

import Foundation


func CsvFormat(_ inString: String) -> String {
    var outString = ""
    if inString.contains(",") {
        outString = "\"" + inString.replacingOccurrences(of: "\"", with: "'") + "\""
    }
    else {
        outString = inString
    }
    return outString
}
