//
//  NumberFieldWidget+CoreDataProperties.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/27/22.
//

import Foundation
import CoreData


extension NumberFieldWidget {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<NumberFieldWidget> {
        return NSFetchRequest<NumberFieldWidget>(entityName: "NumberFieldWidget")
    }
    
    @NSManaged public var number: String?
}
