//
//  JsonFileDocument.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/18/22.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct FormaticFileDocument: FileDocument {
    
    static var readableContentTypes: [UTType] = [.form]
    var jsonData: Data
    
    init(jsonData: Data) {
        self.jsonData = jsonData
    }
    
    // decodes .form
    init(configuration: ReadConfiguration) throws {
        jsonData = configuration.file.regularFileContents ?? Data()
    }
    
    // encodes .form
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: jsonData)
    }
}
