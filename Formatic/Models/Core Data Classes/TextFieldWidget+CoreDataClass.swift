//
//  TextFieldWidget+CoreDataClass.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import Foundation
import CoreData

@objc(TextFieldWidget)
public class TextFieldWidget: Widget, Decodable {
    
    init(title: String?, position: Int, text: String?) {
        super.init(entityName: WidgetType.textFieldWidget.rawValue, context: DataControllerModel.shared.container.viewContext, title: title, position: position)
        self.type = WidgetType.textFieldWidget.rawValue
        self.text = text
    }
    
    required public init(from decoder: Decoder) throws {
        super.init(entityName: WidgetType.textFieldWidget.rawValue, context: DataControllerModel.shared.container.viewContext, title: nil, position: 0)
        
        let textFieldWidgetContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.position = try textFieldWidgetContainer.decode(Int16.self, forKey: .position)
        if let title = try textFieldWidgetContainer.decode(String?.self, forKey: .title) {
            self.title = title
        }
        self.type = try textFieldWidgetContainer.decode(String.self, forKey: .type)
        if let text = try textFieldWidgetContainer.decode(String?.self, forKey: .text) {
            self.text = text
        }
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        
        var textFieldWidgetContainer = encoder.container(keyedBy: CodingKeys.self)
        try textFieldWidgetContainer.encode(text, forKey: .text)
    }
}
