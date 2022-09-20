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
        
        // For each checkbox, add a row
        for cb in checkboxItems ?? [] {
            retString += FormModel.csvFormat(self.section?.title ?? "") + ","
            retString += FormModel.csvFormat(self.title ?? "") + ","
            retString += "Checkbox,"
            retString += FormModel.csvFormat(cb.title ?? "") + ","
            if cb.checked == true {
                retString += "True"
            }
            else {
                retString += "False"
            }
            retString += ",,,,,,\n" // Add leftover data points
        }
        
        // Remove traling newline character (if retString exists/values exist in dropdown)
        if retString != "" {
            retString.remove(at: retString.index(before: retString.endIndex))
        }
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
