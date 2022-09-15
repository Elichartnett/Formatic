//
//  GlobalFunctions.swift
//  Formatic
//
//  Created by Tanner Hess on 9/7/22.
//

import Foundation


func CsvFormat(_ inString: String) -> String {
    var outString = ""
    
    if inString.contains("\""){
        // In case user *specifcally* used normal quotes in their text
        outString = inString.replacingOccurrences(of: "\"", with: "“")
    }
    else {
        outString = inString
    }
    
    // Add single quotes in case of commas present in text
    if outString.contains(",") || inString.contains("\n") {
        outString = "\"" + outString + "\""
    }
    
    return outString
}
