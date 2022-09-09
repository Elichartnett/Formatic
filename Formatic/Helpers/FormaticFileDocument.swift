//
//  FormaticFileDocument.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/18/22.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct FormaticFileDocument: FileDocument {
    
    static var readableContentTypes: [UTType] = [.form, .pdf, .commaSeparatedText]
    var documentData: Data
    
    init(documentData: Data) {
        self.documentData = documentData
    }
    
    // reads
    init(configuration: ReadConfiguration) throws {
        documentData = configuration.file.regularFileContents ?? Data()
    }
    
    // writes
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: documentData)
    }
}
