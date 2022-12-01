//
//  CheckboxWidget+CoreDataProperties.swift
// Formatic
//
//  Created by Eli Hartnett on 4/30/22.
//

import Foundation
import CoreData


extension CheckboxWidget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CheckboxWidget> {
        return NSFetchRequest<CheckboxWidget>(entityName: "CheckboxWidget")
    }

    @NSManaged public var checked: Bool
    @NSManaged public var checkboxSectionWidget: CheckboxSectionWidget?
}
