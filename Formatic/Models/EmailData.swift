//
//  EmailData.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/17/22.
//

import Foundation

struct EmailData {
    var subject: String = Constants.emptyString
    var recipients: [String]?
    var body: String = Constants.emptyString
    var isBodyHTML = false
    var attachments = [AttachmentData]()
    
    struct AttachmentData {
        var data: Data
        var mimeType: String
        var fileName: String
    }
}
