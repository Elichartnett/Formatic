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
    
    init(entityName: String, context: NSManagedObjectContext, title: String?, position: Int) {
        super.init(entity: NSEntityDescription.entity(forEntityName: entityName, in: context)!, insertInto: context)
        self.id = UUID()
        self.title = title
        self.position = Int16(position)
    }
    
    public func encode(to encoder: Encoder) throws {
        var widgetContainer = encoder.container(keyedBy: CodingKeys.self)
        try widgetContainer.encode(position, forKey: .position)
        try widgetContainer.encode(title, forKey: .title)
        try widgetContainer.encode(type, forKey: .type)
    }
}
