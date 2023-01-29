//
//  DropdownSectionWidget+CoreDataClass.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/27/22.
//

import Foundation
import CoreData

@objc(DropdownSectionWidget)
public class DropdownSectionWidget: Widget, Decodable {
    
    init(title: String?, position: Int, selectedDropdown: DropdownWidget?, dropdownWidgets: NSSet?) {
        super.init(entityName: WidgetType.dropdownSectionWidget.rawValue, context: DataControllerModel.shared.container.viewContext, title: title, position: position)
        self.type = WidgetType.dropdownSectionWidget.rawValue
        self.selectedDropdown = selectedDropdown
        self.dropdownWidgets = dropdownWidgets
    }
    
    required public init(from decoder: Decoder) throws {
        super.init(entityName: WidgetType.dropdownSectionWidget.rawValue, context: DataControllerModel.shared.container.viewContext, title: nil, position: 0)
        
        let dropdownSectionWidgetContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.position = try dropdownSectionWidgetContainer.decode(Int16.self, forKey: .position)
        if let title = try dropdownSectionWidgetContainer.decode(String?.self, forKey: .title) {
            self.title = title
        }
        self.type = try dropdownSectionWidgetContainer.decode(String.self, forKey: .type)
        
        if let selectedDropdown = try dropdownSectionWidgetContainer.decode(DropdownWidget?.self, forKey: .selectedDropdown) {
            self.selectedDropdown = selectedDropdown
        }
        let dropdownWidgetsArray = try dropdownSectionWidgetContainer.decode([DropdownWidget].self, forKey: .dropdownWidgets)
        for dropdownWidget in dropdownWidgetsArray {
            self.addToDropdownWidgets(dropdownWidget)
        }
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        
        var dropdownSectionWidgetContainer = encoder.container(keyedBy: CodingKeys.self)
        try dropdownSectionWidgetContainer.encode(selectedDropdown, forKey: .selectedDropdown)
        
        let dropdownWidgetsArray = dropdownWidgets?.allObjects as? [DropdownWidget]
        try dropdownSectionWidgetContainer.encode(selectedDropdown, forKey: .selectedDropdown)
        try dropdownSectionWidgetContainer.encode(dropdownWidgetsArray, forKey: .dropdownWidgets)
    }
}
