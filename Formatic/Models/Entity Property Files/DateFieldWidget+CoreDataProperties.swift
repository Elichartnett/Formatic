//
//  DateFieldWidget+CoreDataProperties.swift
//  Formatic
//
//  Created by Eli Hartnett on 12/3/22.
//

import Foundation
import CoreData

extension DateFieldWidget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DateFieldWidget> {
        return NSFetchRequest<DateFieldWidget>(entityName: "DateFieldWidget")
    }

    @NSManaged public var date: Date?
}
