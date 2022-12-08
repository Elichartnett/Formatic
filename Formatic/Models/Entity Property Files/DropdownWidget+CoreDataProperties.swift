//
//  DropdownWidget+CoreDataProperties.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/7/22.
//

import Foundation
import CoreData

extension DropdownWidget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DropdownWidget> {
        return NSFetchRequest<DropdownWidget>(entityName: "DropdownWidget")
    }

    @NSManaged public var dropdownSectionWidget: DropdownSectionWidget?
    @NSManaged public var selectedDropdownInverse: DropdownSectionWidget?
}
