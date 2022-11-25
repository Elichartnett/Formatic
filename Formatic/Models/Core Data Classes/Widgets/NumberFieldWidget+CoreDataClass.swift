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
public class NumberFieldWidget: Widget, Decodable, Csv, Copyable {
    
    /// NumberFieldWidget  init
    init(title: String?, position: Int, number: String?) {
        super.init(entityName: "NumberFieldWidget", context: DataControllerModel.shared.container.viewContext, title: title, position: position)
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
        super.init(entityName: "NumberFieldWidget", context: DataControllerModel.shared.container.viewContext, title: nil, position: 0)
        
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
    
    func toCsv() -> String {
        var csvString = ""
        csvString += FormModel.formatAsCsv(section?.form?.title ?? "") + ","
        csvString += FormModel.formatAsCsv(section?.title ?? "") + ","
        csvString += FormModel.formatAsCsv(title ?? "") + ","
        csvString += Strings.numberFieldLabel + ","
        csvString += FormModel.formatAsCsv(number ?? "") + ","
        csvString += String(repeating: ",", count: Strings.mapCSVColumns.filter({ character in
            character == ","
        }).count) + ","
        return csvString
    }
    
    func createCopy() -> Any {
        let copy = NumberFieldWidget(title: title, position: Int(position), number: number)
        return copy
    }
}
