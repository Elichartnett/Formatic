//
//  Form+CoreDataProperties.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/30/22.
//

import Foundation
import CoreData

extension Form {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Form> {
        return NSFetchRequest<Form>(entityName: "Form")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var dateCreated: Date
    @NSManaged public var locked: Bool
    @NSManaged public var password: String?
    @NSManaged public var recentlyDeleted: Bool
    @NSManaged public var title: String?
    @NSManaged public var sections: Set<Section>?
}

// MARK: Generated accessors for sections
extension Form {
    
    @objc(addSectionsObject:)
    @NSManaged public func addToSections(_ value: Section)
    
    @objc(removeSectionsObject:)
    @NSManaged public func removeFromSections(_ value: Section)
    
    @objc(addSections:)
    @NSManaged public func addToSections(_ values: NSSet)
    
    @objc(removeSections:)
    @NSManaged public func removeFromSections(_ values: NSSet)
}
