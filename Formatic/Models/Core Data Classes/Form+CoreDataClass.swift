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
        case id = "id"
        case locked = "locked"
        case password = "password"
        case title = "title"
        case sections = "sections"
    }
    
    public func encode(to encoder: Encoder) throws {
        var formContainer = encoder.container(keyedBy: CodingKeys.self)
        
        try formContainer.encode(id, forKey: .id)
        try formContainer.encode(locked, forKey: .locked)
        try formContainer.encode(password, forKey: .password)
        try formContainer.encode(title, forKey: .title)
        try formContainer.encode(sections, forKey: .sections)
    }
    
    required public convenience init(from decoder: Decoder) throws {
        self.init(context: DataController.shared.container.viewContext)
        
        let formContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try formContainer.decode(UUID.self, forKey: .id)
        self.locked = try formContainer.decode(Bool.self, forKey: .locked)
        self.password = try formContainer.decode(String.self, forKey: .password)
        self.title = try formContainer.decode(String.self, forKey: .title)
        self.sections = try formContainer.decode(Set<Section>.self, forKey: .sections)
    }
}
