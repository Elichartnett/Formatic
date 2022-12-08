//
//  Widget+CoreDataProperties.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/30/22.
//

import Foundation
import CoreData

extension Widget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Widget> {
        return NSFetchRequest<Widget>(entityName: "Widget")
    }

    @NSManaged public var id: UUID
    @NSManaged public var position: Int16
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var section: Section?
}
