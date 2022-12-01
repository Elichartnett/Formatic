//
//  DropdownSectionWidget+CoreDataProperties.swift
// Formatic
//
//  Created by Eli Hartnett on 4/27/22.
//

import Foundation
import CoreData
import SwiftUI


extension DropdownSectionWidget {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DropdownSectionWidget> {
        return NSFetchRequest<DropdownSectionWidget>(entityName: "DropdownSectionWidget")
    }
    
    @NSManaged public var selectedDropdown: DropdownWidget?
    @NSManaged public var dropdownWidgets: NSSet?
}

// MARK: Generated accessors for dropdownWidgets
extension DropdownSectionWidget {
    
    @objc(addDropdownWidgetsObject:)
    @NSManaged public func addToDropdownWidgets(_ value: DropdownWidget)
    
    @objc(removeDropdownWidgetsObject:)
    @NSManaged public func removeFromDropdownWidgets(_ value: DropdownWidget)
    
    @objc(addDropdownWidgets:)
    @NSManaged public func addToDropdownWidgets(_ values: NSSet)
    
    @objc(removeDropdownWidgets:)
    @NSManaged public func removeFromDropdownWidgets(_ values: NSSet)
    
}
