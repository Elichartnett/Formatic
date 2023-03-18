//
//  NumberFieldWidget+CoreDataClass.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/27/22.
//

import Foundation
import CoreData

@objc(NumberFieldWidget)
public class NumberFieldWidget: Widget, Decodable {
    
    init(title: String?, position: Int, number: String) {
        super.init(entityName: WidgetType.numberFieldWidget.rawValue, context: DataControllerModel.shared.container.viewContext, title: title, position: position)
        self.type = WidgetType.numberFieldWidget.rawValue
        self.number = number
    }
    
    required public init(from decoder: Decoder) throws {
        super.init(entityName: WidgetType.numberFieldWidget.rawValue, context: DataControllerModel.shared.container.viewContext, title: nil, position: 0)
        
        let numberFieldWidgetContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.position = try numberFieldWidgetContainer.decode(Int16.self, forKey: .position)
        if let title = try numberFieldWidgetContainer.decode(String?.self, forKey: .title) {
            self.title = title
        }
        self.type = try numberFieldWidgetContainer.decode(String.self, forKey: .type)
        self.number = try numberFieldWidgetContainer.decode(String.self, forKey: .number)
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        
        var numberFieldWidgetContainer = encoder.container(keyedBy: CodingKeys.self)
        try numberFieldWidgetContainer.encode(number, forKey: .number)
    }
}
