//
//  DateFieldWidget+CoreDataClass.swift
//  Formatic
//
//  Created by Eli Hartnett on 12/3/22.
//

import Foundation
import CoreData

@objc(DateFieldWidget)
public class DateFieldWidget: Widget, Decodable {

    init(title: String?, position: Int, date: Date?) {
        super.init(entityName: WidgetType.dateFieldWidget.rawValue, context: DataControllerModel.shared.container.viewContext, title: title, position: position)
        self.type = WidgetType.dateFieldWidget.rawValue
        self.date = date
    }
    
    required public init(from decoder: Decoder) throws {
        super.init(entityName: WidgetType.dateFieldWidget.rawValue, context: DataControllerModel.shared.container.viewContext, title: nil, position: 0)
        
        let dateFieldWidgetContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.position = try dateFieldWidgetContainer.decode(Int16.self, forKey: .position)
        if let title = try dateFieldWidgetContainer.decode(String?.self, forKey: .title) {
            self.title = title
        }
        self.type = try dateFieldWidgetContainer.decode(String.self, forKey: .type)
        if let date = try dateFieldWidgetContainer.decode(Date?.self, forKey: .date) {
            self.date = date
        }
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        
        var dateFieldWidgetContainer = encoder.container(keyedBy: CodingKeys.self)
        try dateFieldWidgetContainer.encode(date, forKey: .date)
    }
}
