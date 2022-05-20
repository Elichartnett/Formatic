//
//  Form+CoreDataClass.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/30/22.
//
//

import Foundation
import CoreData

@objc(Form)
public class Form: NSManagedObject, Codable {

    enum CodingKeys: String, CodingKey {
        case locked = "locked"
        case password = "password"
        case title = "title"
        case sections = "sections"
    }
    
    public func encode(to encoder: Encoder) throws {
        var formContainer = encoder.container(keyedBy: CodingKeys.self)
        
        try formContainer.encode(locked, forKey: .locked)
        try formContainer.encode(password, forKey: .password)
        try formContainer.encode(title, forKey: .title)
        try formContainer.encode(sections, forKey: .sections)
    }
    
    required public convenience init(from decoder: Decoder) throws {
        self.init(context: DataController.shared.container.viewContext)
        
        let formContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.locked = try formContainer.decode(Bool.self, forKey: .locked)
        if let password = try formContainer.decode(String?.self, forKey: .password) {
            self.password = password
        }
        else {
            self.password = nil
        }
        self.position = Int16(try DataController.shared.container.viewContext.fetch(NSFetchRequest(entityName: "Form")).count)
        if let title = try formContainer.decode(String?.self, forKey: .title) {
            self.title = title
        }
        else {
            self.title = nil
        }
        if let sections = try formContainer.decode(Set<Section>?.self, forKey: .sections) {
            self.sections = sections
        }
        else {
            sections = nil
        }
    }
}
