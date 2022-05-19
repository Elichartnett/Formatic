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
public class Widget: NSManagedObject, Codable {
    
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
    
    required public convenience init(from decoder: Decoder) throws {
        self.init(context: DataController.shared.container.viewContext)

        let widgetContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.position = try widgetContainer.decode(Int16.self, forKey: .position)
        self.title = try widgetContainer.decode(String.self, forKey: .title)
        self.type = try widgetContainer.decode(String.self, forKey: .type)
    }
}
