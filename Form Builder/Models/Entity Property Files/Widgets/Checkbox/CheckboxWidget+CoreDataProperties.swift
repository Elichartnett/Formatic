//
//  CheckboxWidget+CoreDataProperties.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/30/22.
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
    convenience init(title: String?) {
        self.init(title: title, entity: "CheckboxWidget")
        self.checked = false
    }
}
