//
//  CheckboxWidget+CoreDataClass.swift
// Formatic
//
//  Created by Eli Hartnett on 4/27/22.
//
//

import Foundation
import CoreData

@objc(CheckboxWidget)
public class CheckboxWidget: Widget, Decodable, Copyable {
    
    /// CheckboxWidget  init
    init(title: String?, position: Int, checked: Bool, checkboxSectionWidget: CheckboxSectionWidget?) {
        super.init(entityName: "CheckboxWidget", context: DataControllerModel.shared.container.viewContext, title: title, position: position)
        self.type = WidgetType.checkboxWidget.rawValue
        self.checked = checked
        self.checkboxSectionWidget = checkboxSectionWidget
    }
    
    enum CodingKeys: String, CodingKey {
        case position = "position"
        case title = "title"
        case type = "type"
        case checked = "checked"
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        
        var checkboxWidgetContainer = encoder.container(keyedBy: CodingKeys.self)
        try checkboxWidgetContainer.encode(checked, forKey: .checked)
        // checkboxSectionWidget linked in CheckboxSectionWidget and is not encoded here (would cause infinite loop)
    }
    
    required public init(from decoder: Decoder) throws {
        super.init(entityName: "CheckboxWidget", context: DataControllerModel.shared.container.viewContext, title: nil, position: 0)

        let checkboxWidgetContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.position = try checkboxWidgetContainer.decode(Int16.self, forKey: .position)
        if let title = try checkboxWidgetContainer.decode(String?.self, forKey: .title) {
            self.title = title
        }
        self.type = try checkboxWidgetContainer.decode(String.self, forKey: .type)
        self.checked = try checkboxWidgetContainer.decode(Bool.self, forKey: .checked)
        // checkboxSectionWidget linked in CheckboxSectionWidget and is not decoded here (would cause infinite loop)
    }
    
    func createCopy() -> Any {
        let copy = CheckboxWidget(title: title, position: Int(position), checked: checked, checkboxSectionWidget: nil)
        return copy
    }
}
