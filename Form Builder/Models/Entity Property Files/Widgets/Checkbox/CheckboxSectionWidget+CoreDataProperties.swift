//
//  CheckboxSectionWidget+CoreDataProperties.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/27/22.
//
//

import Foundation
import CoreData


extension CheckboxSectionWidget {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CheckboxSectionWidget> {
        return NSFetchRequest<CheckboxSectionWidget>(entityName: "CheckboxSectionWidget")
    }
    
    @NSManaged public var checkboxes: NSSet?
    
    public var checkboxesArray: [CheckboxWidget] {
        let set = checkboxes as? Set<CheckboxWidget> ?? []
        return Array(set)
    }
    
    /// CheckboxSectionWidget  convenience init
    convenience init(title: String?, position: Int) {
        self.init(title: title, position: position, type: WidgetType.checkboxSectionWidget.rawValue)
    }
}

// MARK: Generated accessors for checkboxes
extension CheckboxSectionWidget {
    
    @objc(addCheckboxesObject:)
    @NSManaged public func addToCheckboxes(_ value: CheckboxWidget)
    
    @objc(removeCheckboxesObject:)
    @NSManaged public func removeFromCheckboxes(_ value: CheckboxWidget)
    
    @objc(addCheckboxes:)
    @NSManaged public func addToCheckboxes(_ values: NSSet)
    
    @objc(removeCheckboxes:)
    @NSManaged public func removeFromCheckboxes(_ values: NSSet)
    
}
