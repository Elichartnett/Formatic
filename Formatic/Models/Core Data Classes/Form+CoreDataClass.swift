//
//  Form+CoreDataClass.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/30/22.
//
//

import Foundation
import CoreData
import CryptoKit

@objc(Form)
public class Form: NSManagedObject, Codable, Identifiable, Csv, Copyable {
    
    enum CodingKeys: String, CodingKey {
        case dateCreated = "dateCreated"
        case locked = "locked"
        case password = "password"
        case title = "title"
        case sections = "sections"
    }
    
    public func encode(to encoder: Encoder) throws {
        var formContainer = encoder.container(keyedBy: CodingKeys.self)
        
        try formContainer.encode(dateCreated, forKey: .dateCreated)
        try formContainer.encode(locked, forKey: .locked)
        try formContainer.encode(title, forKey: .title)
        try formContainer.encode(sections, forKey: .sections)
        
        if let password {
            let hash = SHA256.hash(data: dateCreated.timeIntervalSince1970.description.data(using: .utf8)!)
            let key = SymmetricKey(data: hash)
            let passwordData = password.data(using: .utf8)!
            let sealedBoxData = try! ChaChaPoly.seal(passwordData, using: key).combined
            try formContainer.encode(sealedBoxData, forKey: .password)
        }
    }
    
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
        
        if let sealedBoxData = try formContainer.decode(Data?.self, forKey: .password) {
            let hash = SHA256.hash(data: dateCreated.timeIntervalSince1970.description.data(using: .utf8)!)
            let key = SymmetricKey(data: hash)
            let sealedBox = try! ChaChaPoly.SealedBox(combined: sealedBoxData)
            let passwordData = try! ChaChaPoly.open(sealedBox, using: key)
            self.password = String(data: passwordData, encoding: .utf8)
        }
    }
    
    func toCsv() -> String {
        var csvString = Strings.baseCSVColumns + Strings.mapCSVColumns
        
        let sections = (sections ?? []).sorted { lhs, rhs in
            lhs.position < rhs.position
        }
                
        for section in sections {
            csvString += section.toCsv()
            csvString += "\n\n"
        }
        // Remove trailing newline characters
        csvString.remove(at: csvString.index(before: csvString.endIndex))
        csvString.remove(at: csvString.index(before: csvString.endIndex))
        return csvString
    }
    
    func createCopy() -> Any {
        let copy = Form(position: Int(self.position), title: self.title!)
        copy.locked = locked
        copy.password = password
        
        let sectionsArray = sections?.sorted(by: { lhs, rhs in
            lhs.position < rhs.position
        }) ?? []
        for section in sectionsArray {
            let sectionCopy = section.createCopy() as! Section
            copy.addToSections(sectionCopy)
        }
        return copy
    }
}
