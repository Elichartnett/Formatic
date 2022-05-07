//
//  DropdownWidget+CoreDataProperties.swift
// Formatic
//
//  Created by Eli Hartnett on 4/30/22.
//
//

import Foundation
import CoreData


extension DropdownWidget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DropdownWidget> {
        return NSFetchRequest<DropdownWidget>(entityName: "DropdownWidget")
    }

    @NSManaged public var dropdownSection: DropdownSectionWidget?
    @NSManaged public var sectionWithSelection: DropdownSectionWidget?

    /// DropdownWidget  convenience init
    convenience init(title: String?, position: Int) {
        self.init(title: title, position: position, type: WidgetType.dropdownWidget.rawValue)
    }
}
