//
//  TextEditorWidget+CoreDataClass.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/27/22.
//
//

import Foundation
import CoreData

@objc(TextEditorWidget)
public class TextEditorWidget: Widget, Decodable, CSV {
    
    func ToCsv() -> String {
        var retString = ""
        retString += FormModel.csvFormat(self.section?.title ?? "") + ","
        retString += FormModel.csvFormat(self.title ?? "") + ","
        retString += (self.type ?? "") + ","
        retString += FormModel.csvFormat(self.text ?? "") + ","
        retString += ",,,,,,"
        return retString
    }
    
    /// TextEditorWidget  init
    init(title: String?, position: Int, text: String?) {
        super.init(entityName: "TextEditorWidget", context: DataController.shared.container.viewContext, title: title, position: position)
        self.type = WidgetType.textEditorWidget.rawValue
        self.text = text
    }

    enum CodingKeys: String, CodingKey {
        case position = "position"
        case title = "title"
        case type = "type"
        case text = "text"
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        
        var textEditorWidgetContainer = encoder.container(keyedBy: CodingKeys.self)
        try textEditorWidgetContainer.encode(text, forKey: .text)
    }
    
    required public init(from decoder: Decoder) throws {
        super.init(entityName: "TextEditorWidget", context: DataController.shared.container.viewContext, title: nil, position: 0)

        let textEditorWidgetContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.position = try textEditorWidgetContainer.decode(Int16.self, forKey: .position)
        if let title = try textEditorWidgetContainer.decode(String?.self, forKey: .title) {
            self.title = title
        }
        self.type = try textEditorWidgetContainer.decode(String.self, forKey: .type)
        if let text = try textEditorWidgetContainer.decode(String?.self, forKey: .text) {
            self.text = text
        }
    }
}
