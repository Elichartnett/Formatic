//
//  Form+CoreDataClass.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/30/22.
//

import Foundation
import CoreData
import CryptoKit
import SwiftUI

@objc(Form)
public class Form: NSManagedObject {
    
    required public convenience init(from decoder: Decoder) throws {
        self.init(context: DataControllerModel.shared.container.viewContext)
        
        let formContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.dateCreated = try formContainer.decode(Date.self, forKey: .dateCreated)
        self.locked = try formContainer.decode(Bool.self, forKey: .locked)
        if let title = try formContainer.decode(String?.self, forKey: .title) {
            self.title = title
        }
        if let sections = try formContainer.decode(Set<Section>?.self, forKey: .sections) {
            self.sections = sections
        }
        
        do {
            if let sealedBoxData = try? formContainer.decode(Data?.self, forKey: .password) {
                let hash = SHA256.hash(data: dateCreated.timeIntervalSince1970.description.data(using: .utf8)!)
                let key = SymmetricKey(data: hash)
                let sealedBox = try! ChaChaPoly.SealedBox(combined: sealedBoxData)
                let passwordData = try! ChaChaPoly.open(sealedBox, using: key)
                self.password = String(data: passwordData, encoding: .utf8)
            }
        }
    }
}
