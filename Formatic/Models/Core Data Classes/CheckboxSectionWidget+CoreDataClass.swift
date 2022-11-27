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
public class CheckboxSectionWidget: Widget, Decodable {
    
    init(title: String?, position: Int, checkboxWidgets: NSSet?) {
        super.init(entityName: Constants.checkboxSectionWidgetEntityName, context: DataControllerModel.shared.container.viewContext, title: title, position: position)
        self.type = WidgetType.checkboxSectionWidget.rawValue
        self.checkboxWidgets = checkboxWidgets
    }
    
    required public init(from decoder: Decoder) throws {
        super.init(entityName: Constants.checkboxSectionWidgetEntityName, context: DataControllerModel.shared.container.viewContext, title: nil, position: 0)
        
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
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        
        var checkboxSectionWidgetContainer = encoder.container(keyedBy: CodingKeys.self)
        let checkboxWidgetsArray = checkboxWidgets?.allObjects as? [CheckboxWidget]
        try checkboxSectionWidgetContainer.encode(checkboxWidgetsArray, forKey: .checkboxWidgets)
    }
}
