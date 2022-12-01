//
//  CheckboxSectionWidget+CoreDataProperties.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/7/22.
//

import Foundation
import CoreData


extension CheckboxSectionWidget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CheckboxSectionWidget> {
        return NSFetchRequest<CheckboxSectionWidget>(entityName: "CheckboxSectionWidget")
    }

    @NSManaged public var checkboxWidgets: NSSet?
}

// MARK: Generated accessors for checkboxWidgets
extension CheckboxSectionWidget {

    @objc(addCheckboxWidgetsObject:)
    @NSManaged public func addToCheckboxWidgets(_ value: CheckboxWidget)

    @objc(removeCheckboxWidgetsObject:)
    @NSManaged public func removeFromCheckboxWidgets(_ value: CheckboxWidget)

    @objc(addCheckboxWidgets:)
    @NSManaged public func addToCheckboxWidgets(_ values: NSSet)

    @objc(removeCheckboxWidgets:)
    @NSManaged public func removeFromCheckboxWidgets(_ values: NSSet)

}
