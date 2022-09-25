//
//  DropdownWidget+CoreDataClass.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/30/22.
//
//

import Foundation
import CoreData

@objc(DropdownWidget)
public class DropdownWidget: Widget, Decodable, Copyable {

    /// DropdownWidget  init
    init(title: String?, position: Int, dropdownSectionWidget: DropdownSectionWidget?, selectedDropdownInverse: DropdownSectionWidget?) {
        super.init(entityName: "DropdownWidget", context: DataControllerModel.shared.container.viewContext, title: title, position: position)
        self.type = WidgetType.dropdownWidget.rawValue
        self.dropdownSectionWidget = dropdownSectionWidget
        self.selectedDropdownInverse = selectedDropdownInverse
    }
    
    enum CodingKeys: String, CodingKey {
        case position = "position"
        case title = "title"
        case type = "type"
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        // dropdownSectionWidget and selectedDropdownInverse set in DropdownSectionWidget and is not encoded here (would cause infinite loop)
    }
    
    required public init(from decoder: Decoder) throws {
        super.init(entityName: "DropdownWidget", context: DataControllerModel.shared.container.viewContext, title: nil, position: 0)

        let dropdownWidgetWidgetContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.position = try dropdownWidgetWidgetContainer.decode(Int16.self, forKey: .position)
        if let title = try dropdownWidgetWidgetContainer.decode(String?.self, forKey: .title) {
            self.title = title
        }
        self.type = try dropdownWidgetWidgetContainer.decode(String.self, forKey: .type)
        // dropdownSectionWidget and selectedDropdownInverse set in DropdownSectionWidget and is not encoded here (would cause infinite loop)
    }
    
    func createCopy() -> Any {
        let copy = DropdownWidget(title: title, position: Int(position), dropdownSectionWidget: nil, selectedDropdownInverse: nil)
        return copy
    }
}
