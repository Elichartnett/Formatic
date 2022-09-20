//
//  DropdownSectionWidget+CoreDataClass.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/27/22.
//
//

import Foundation
import CoreData

@objc(DropdownSectionWidget)
public class DropdownSectionWidget: Widget, Decodable, CSV {
    
    func toCsv() -> String {
        
        var dropdownItems = self.dropdownWidgets?.map( {$0 as! DropdownWidget})
        if dropdownItems != [] {
            dropdownItems = (dropdownItems)!.sorted { lhs, rhs in
                lhs.position < rhs.position
            }
        }
        
        var retString = ""
        // For each dropdown, add a row
        for dd in dropdownItems ?? [] {
            retString += FormModel.csvFormat(self.section?.title ?? "") + ","
            retString += FormModel.csvFormat(self.title ?? "") + ","
            retString += "Dropdown,"
            retString += FormModel.csvFormat(dd.title ?? "") + ","
            if self.selectedDropdown == dd {
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
    
    /// DropdownSectionWidget  init
    init(title: String?, position: Int, selectedDropdown: DropdownWidget?, dropdownWidgets: NSSet?) {
        super.init(entityName: "DropdownSectionWidget", context: DataController.shared.container.viewContext, title: title, position: position)
        self.type = WidgetType.dropdownSectionWidget.rawValue
        self.selectedDropdown = selectedDropdown
        self.dropdownWidgets = dropdownWidgets
    }
    
    enum CodingKeys: String, CodingKey {
        case position = "position"
        case title = "title"
        case type = "type"
        case selectedDropdown = "selectedDropdown"
        case dropdownWidgets = "dropdownWidgets"
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        
        var dropdownSectionWidgetContainer = encoder.container(keyedBy: CodingKeys.self)
        try dropdownSectionWidgetContainer.encode(selectedDropdown, forKey: .selectedDropdown)
        
        let dropdownWidgetsArray = dropdownWidgets?.allObjects as? [DropdownWidget]
        try dropdownSectionWidgetContainer.encode(selectedDropdown, forKey: .selectedDropdown)
        try dropdownSectionWidgetContainer.encode(dropdownWidgetsArray, forKey: .dropdownWidgets)
    }
    
    required public init(from decoder: Decoder) throws {
        super.init(entityName: "DropdownSectionWidget", context: DataController.shared.container.viewContext, title: nil, position: 0)

        let dropdownSectionWidgetContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.position = try dropdownSectionWidgetContainer.decode(Int16.self, forKey: .position)
        if let title = try dropdownSectionWidgetContainer.decode(String?.self, forKey: .title) {
            self.title = title
        }
        self.type = try dropdownSectionWidgetContainer.decode(String.self, forKey: .type)
        
        self.selectedDropdown = try dropdownSectionWidgetContainer.decode(DropdownWidget.self, forKey: .selectedDropdown)
        let dropdownWidgetsArray = try dropdownSectionWidgetContainer.decode([DropdownWidget].self, forKey: .dropdownWidgets)
        for dropdownWidget in dropdownWidgetsArray {
            self.addToDropdownWidgets(dropdownWidget)
        }
    }
}
