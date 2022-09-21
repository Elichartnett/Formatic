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
public class DropdownSectionWidget: Widget, Decodable, Csv {
    
    /// DropdownSectionWidget  init
    init(title: String?, position: Int, selectedDropdown: DropdownWidget?, dropdownWidgets: NSSet?) {
        super.init(entityName: "DropdownSectionWidget", context: DataControllerModel.shared.container.viewContext, title: title, position: position)
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
        super.init(entityName: "DropdownSectionWidget", context: DataControllerModel.shared.container.viewContext, title: nil, position: 0)
        
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
    
    func toCsv() -> String {
        var csvString = ""
        
        if var dropdownWidgets = self.dropdownWidgets?.map( {$0 as! DropdownWidget}) {
            dropdownWidgets = dropdownWidgets.sorted { lhs, rhs in
                lhs.position < rhs.position
            }
            
            // For each dropdown, add a row
            for dropdownWidget in dropdownWidgets {
                csvString += FormModel.formatAsCsv(self.section?.title ?? "") + ","
                csvString += FormModel.formatAsCsv(self.title ?? "") + ","
                csvString += "Dropdown,"
                csvString += FormModel.formatAsCsv(dropdownWidget.title ?? "") + ","
                if self.selectedDropdown == dropdownWidget {
                    csvString += "True"
                }
                else {
                    csvString += "False"
                }
                csvString += ",,,,,,\n" // Add leftover data points
            }
            
            // Remove traling newline character (if csvString/values exist in dropdown)
            if csvString != "" {
                csvString.remove(at: csvString.index(before: csvString.endIndex))
            }
        }
        
        return csvString
    }
}
