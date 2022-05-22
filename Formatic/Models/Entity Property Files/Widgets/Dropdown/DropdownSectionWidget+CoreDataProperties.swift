//
//  DropdownSectionWidget+CoreDataProperties.swift
// Formatic
//
//  Created by Eli Hartnett on 4/27/22.
//
//

import Foundation
import CoreData
import SwiftUI


extension DropdownSectionWidget {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DropdownSectionWidget> {
        return NSFetchRequest<DropdownSectionWidget>(entityName: "DropdownSectionWidget")
    }
    
    @NSManaged public var selectedDropdown: DropdownWidget?
    @NSManaged public var dropdowns: NSSet?
    
    /// DropdownSectionWidget  convenience init
    convenience init(title: String?, position: Int) {
        self.init(title: title, position: position, type: WidgetType.dropdownSectionWidget.rawValue)
    }
}

// MARK: Generated accessors for dropdowns
extension DropdownSectionWidget {
    
    @objc(addDropdownsObject:)
    @NSManaged public func addToDropdowns(_ value: DropdownWidget)
    
    @objc(removeDropdownsObject:)
    @NSManaged public func removeFromDropdowns(_ value: DropdownWidget)
    
    @objc(addDropdowns:)
    @NSManaged public func addToDropdowns(_ values: NSSet)
    
    @objc(removeDropdowns:)
    @NSManaged public func removeFromDropdowns(_ values: NSSet)
    
}
