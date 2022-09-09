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
    
    func ToCsv() -> String {
        
        var dropdownItems = self.dropdownWidgets?.map( {$0 as! DropdownWidget})
        if dropdownItems != [] {
            dropdownItems = (dropdownItems)!.sorted { lhs, rhs in
                lhs.position < rhs.position
            }
        }
        var retString = ""
        
        // Add first row (titles)
        retString += self.type ?? ""
        retString += ","
        retString += CsvFormat(self.title ?? "")
        retString += ",Titles,"
        for dd in dropdownItems ?? [] {
            if let ddwidget = dd as? DropdownWidget {
                retString += CsvFormat(ddwidget.title ?? "")
                retString += ","
            }
        }
        // Remove trailing comma and add newline character
        retString.remove(at: retString.index(before: retString.endIndex))
        retString += "\n"
        
        retString += ","                // Blank spot for section title
        retString += self.type ?? ""
        retString += ","
        retString += self.title ?? ""
        retString += ",Selected,"
        
        // Add second row (True/False)
        for dd in dropdownItems ?? [] {
            if let ddwidget = dd as? DropdownWidget {
                if self.selectedDropdown == ddwidget {
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
