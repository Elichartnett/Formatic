//
//  NumberFieldWidget+CoreDataClass.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/27/22.
//
//

import Foundation
import CoreData

@objc(NumberFieldWidget)
public class NumberFieldWidget: Widget, Decodable, Csv {
    
    func toCsv() -> String {
        var retString = ""
        retString += FormModel.csvFormat(self.section?.title ?? "") + ","
        retString += FormModel.csvFormat(self.title ?? "") + ","
        retString += (self.type ?? "") + ","
        retString += FormModel.csvFormat(self.number ?? "") + ","
        retString += ",,,,,,"
        return retString
    }
    
    
    /// NumberFieldWidget  init
    init(title: String?, position: Int, number: String?) {
        super.init(entityName: "NumberFieldWidget", context: DataController.shared.container.viewContext, title: title, position: position)
        self.type = WidgetType.numberFieldWidget.rawValue
        self.number = number
    }

    enum CodingKeys: String, CodingKey {
        case position = "position"
        case title = "title"
        case type = "type"
        case number = "number"
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        
        var numberFieldWidgetContainer = encoder.container(keyedBy: CodingKeys.self)
        try numberFieldWidgetContainer.encode(number, forKey: .number)
    }
    
    required public init(from decoder: Decoder) throws {
        super.init(entityName: "NumberFieldWidget", context: DataController.shared.container.viewContext, title: nil, position: 0)

        let numberFieldWidgetContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.position = try numberFieldWidgetContainer.decode(Int16.self, forKey: .position)
        if let title = try numberFieldWidgetContainer.decode(String?.self, forKey: .title) {
            self.title = title
        }
        self.type = try numberFieldWidgetContainer.decode(String.self, forKey: .type)
        if let number = try numberFieldWidgetContainer.decode(String?.self, forKey: .number) {
            self.number = number
        }
    }
}
