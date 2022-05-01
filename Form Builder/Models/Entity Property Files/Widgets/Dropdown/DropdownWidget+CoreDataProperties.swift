//
//  DropdownWidget+CoreDataProperties.swift
//  Form Builder
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

    /// DropdownWidget  convenience init
    convenience init(title: String?) {
        self.init(title: title, entity: "DropdownWidget")
    }
}
