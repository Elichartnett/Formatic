//
//  EmailViewRepresentable.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/17/22.
//

import Foundation
import SwiftUI
import MessageUI

struct EmailViewRepresentable: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) private var presentationMode
    
    let emailData: EmailData
    var result: (Result<MFMailComposeResult, Error>) -> Void
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let emailComposer = MFMailComposeViewController()
        emailComposer.mailComposeDelegate = context.coordinator
        emailComposer.setSubject(emailData.subject)
        emailComposer.setToRecipients(emailData.recipients)
        emailComposer.setMessageBody(emailData.body, isHTML: emailData.isBodyHTML)
        for attachment in emailData.attachments {
            emailComposer.addAttachmentData(attachment.data, mimeType: attachment.mimeType, fileName: attachment.fileName)
        }
        return emailComposer
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: EmailViewRepresentable
        
        init(_ parent: EmailViewRepresentable) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            
            if let error = error {
                parent.result(.failure(error))
                return
            }
            
            parent.result(.success(result))
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    static func canSendEmail() -> Bool {
        MFMailComposeViewController.canSendMail()
    }
}
