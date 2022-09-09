//
//  CheckboxSectionWidget+CoreDataClass.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/7/22.
//
//

import Foundation
import CoreData

@objc(CheckboxSectionWidget)
public class CheckboxSectionWidget: Widget, Decodable, CSV {

    func ToCsv() -> String {
        var checkboxItems = self.checkboxWidgets?.map( {$0 as! CheckboxWidget})
        if checkboxItems != [] {
            checkboxItems = (checkboxItems)!.sorted { lhs, rhs in
                lhs.position < rhs.position
            }
        }
        var retString = ""
        
        // Add first row (titles):
        retString += self.type ?? ""
        retString += ","
        retString += CsvFormat(self.title ?? "")
        retString += ",Titles,"
        for cb in checkboxItems ?? [] {
            if let cbwidget = cb as? CheckboxWidget {
                retString += CsvFormat(cbwidget.title ?? "") + ","
            }
        }
        // Remove trailing comma and add newline character
        retString.remove(at: retString.index(before: retString.endIndex))
        retString += "\n"
        
        retString += ","                // Blank spot for section title
        retString += self.type ?? ""
        retString += ","
        retString += self.title ?? ""
        retString += ",checked,"
        
        // Add second row (True/False)
        for cb in checkboxItems ?? [] {
            if let cbwidget = cb as? CheckboxWidget {
                if cbwidget.checked == true {
                    retString += "True,"
                }
                else {
                    retString += "False,"
                }
            }
        }
        // Remove traling comma
        retString.remove(at: retString.index(before: retString.endIndex))
        return retString
    }
    
    /// CheckboxSectionWidget  init
    init(title: String?, position: Int, checkboxWidgets: NSSet?) {
        super.init(entityName: "CheckboxSectionWidget", context: DataController.shared.container.viewContext, title: title, position: position)
        self.type = WidgetType.checkboxSectionWidget.rawValue
        self.checkboxWidgets = checkboxWidgets
    }
    
    enum CodingKeys: String, CodingKey {
        case position = "position"
        case title = "title"
        case type = "type"
        case checkboxWidgets = "checkboxWidgets"
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        
        var checkboxSectionWidgetContainer = encoder.container(keyedBy: CodingKeys.self)
        let checkboxWidgetsArray = checkboxWidgets?.allObjects as? [CheckboxWidget]
        try checkboxSectionWidgetContainer.encode(checkboxWidgetsArray, forKey: .checkboxWidgets)
    }
    
    required public init(from decoder: Decoder) throws {
        super.init(entityName: "CheckboxSectionWidget", context: DataController.shared.container.viewContext, title: nil, position: 0)

        let checkboxSectionWidgetContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.position = try checkboxSectionWidgetContainer.decode(Int16.self, forKey: .position)
        if let title = try checkboxSectionWidgetContainer.decode(String?.self, forKey: .title) {
            self.title = title
        }
        self.type = try checkboxSectionWidgetContainer.decode(String.self, forKey: .type)
        
        let checkboxWidgetsArray = try checkboxSectionWidgetContainer.decode([CheckboxWidget].self, forKey: .checkboxWidgets)
        for checkboxWidget in checkboxWidgetsArray {
            self.addToCheckboxWidgets(checkboxWidget)
        }
    }
}
