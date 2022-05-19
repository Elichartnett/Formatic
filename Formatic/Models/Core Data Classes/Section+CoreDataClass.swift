//
//  Section+CoreDataClass.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/28/22.
//
//

import Foundation
import CoreData

@objc(Section)
public class Section: NSManagedObject, Codable {

    enum CodingKeys: String, CodingKey {
        case position = "position"
        case title = "title"
        case widgets = "widgets"
    }
    
    public func encode(to encoder: Encoder) throws {
        var sectionContainer = encoder.container(keyedBy: CodingKeys.self)
        
        try sectionContainer.encode(position, forKey: .position)
        try sectionContainer.encode(title, forKey: .title)
        try sectionContainer.encode(widgets, forKey: .widgets)
    }
    
    required public convenience init(from decoder: Decoder) throws {
        self.init(context: DataController.shared.container.viewContext)
        
        let sectionContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.position = try sectionContainer.decode(Int16.self, forKey: .position)
        self.title = try sectionContainer.decode(String.self, forKey: .title)
        self.widgets = try sectionContainer.decode(Set<Widget>.self, forKey: .widgets)
    }
}
