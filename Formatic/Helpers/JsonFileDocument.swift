//
//  JsonFileDocument.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/18/22.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct JsonFileDocument: FileDocument {
    
    static var readableContentTypes: [UTType] = [.json]
    var jsonData: Data
    
    init(jsonData: Data) {
        self.jsonData = jsonData
    }
    
    init(configuration: ReadConfiguration) throws {
        jsonData = Data()
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: jsonData)
    }
    
}
