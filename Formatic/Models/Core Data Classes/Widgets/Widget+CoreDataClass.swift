//
//  Widget+CoreDataClass.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/30/22.
//
//

import Foundation
import CoreData

@objc(Widget)
public class Widget: NSManagedObject, Encodable {
    
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(entityName: String, context: NSManagedObjectContext, title: String?, position: Int) {
        super.init(entity: NSEntityDescription.entity(forEntityName: entityName, in: context)!, insertInto: context)
        
        self.id = UUID()
        self.title = title
        self.position = Int16(position)
    }
    
    enum CodingKeys: String, CodingKey {
        case position = "position"
        case title = "title"
        case type = "type"
    }
    
    public func encode(to encoder: Encoder) throws {
        var widgetContainer = encoder.container(keyedBy: CodingKeys.self)
        
        try widgetContainer.encode(position, forKey: .position)
        try widgetContainer.encode(title, forKey: .title)
        try widgetContainer.encode(type, forKey: .type)
    }
}
