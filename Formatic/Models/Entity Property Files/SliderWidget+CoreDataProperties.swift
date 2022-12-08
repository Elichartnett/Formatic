//
//  SliderWidget+CoreDataProperties.swift
//  Formatic
//
//  Created by Eli Hartnett on 12/3/22.
//

import Foundation
import CoreData

extension SliderWidget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SliderWidget> {
        return NSFetchRequest<SliderWidget>(entityName: "SliderWidget")
    }

    @NSManaged public var lowerBound: String?
    @NSManaged public var step: String?
    @NSManaged public var upperBound: String?
}
