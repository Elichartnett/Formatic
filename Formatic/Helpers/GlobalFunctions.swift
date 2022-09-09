//
//  GlobalFunctions.swift
//  Formatic
//
//  Created by Tanner Hess on 9/7/22.
//

import Foundation


func CsvFormat(_ inString: String) -> String {
    var outString = ""
    if inString.contains(",") || inString.contains("\n") {
        outString = "\"" + inString + "\""
        if inString.contains("\""){
            // In case user *specifcally* used normal quotes in their text
            outString = outString.replacingOccurrences(of: "\"", with: "“")
        }
    }
    else {
        outString = inString
    }
    return outString
}
