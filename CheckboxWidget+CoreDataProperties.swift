//
//  CheckboxWidget+CoreDataProperties.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/7/22.
//
//

import Foundation
import CoreData


extension CheckboxWidget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CheckboxWidget> {
        return NSFetchRequest<CheckboxWidget>(entityName: "CheckboxWidget")
    }

    @NSManaged public var checked: Bool
    @NSManaged public var checkboxSection: CheckboxSectionWidget?

    /// CheckboxWidget  convenience init
    convenience init(title: String?, position: Int) {
        self.init(title: title, position: position, type: WidgetType.checkboxWidget.rawValue)
        self.checked = false
    }
}
