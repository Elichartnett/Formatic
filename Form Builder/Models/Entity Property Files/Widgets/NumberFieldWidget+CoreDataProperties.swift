//
//  NumberFieldWidget+CoreDataProperties.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/27/22.
//
//

import Foundation
import CoreData


extension NumberFieldWidget {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<NumberFieldWidget> {
        return NSFetchRequest<NumberFieldWidget>(entityName: "NumberFieldWidget")
    }
    
    @NSManaged public var number: String?
    
    /// NumberFieldWidget  convenience init
    convenience init(title: String?, position: Double, number: String?) {
        self.init(title: title, position: position, type: "NumberFieldWidget")
        self.number = number
    }
}
