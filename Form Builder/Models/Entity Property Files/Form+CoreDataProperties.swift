//
//  Form+CoreDataProperties.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/30/22.
//
//

import Foundation
import CoreData


extension Form {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Form> {
        return NSFetchRequest<Form>(entityName: "Form")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var locked: Bool
    @NSManaged public var title: String?
    @NSManaged public var sections: NSSet?
    
    /// Form convenience init
    convenience init(id: UUID = UUID(), title: String, locked: Bool = false) {
        self.init(context: DataController.shared.container.viewContext)
        self.id = id
        self.title = title
        self.locked = locked
    }
    
    var sectionsArray: [Section] {
        let set = sections as? Set<Section> ?? []
        return set.sorted { lhs, rhs in
            lhs.title ?? "" < rhs.title ?? ""
        }
    }
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

extension Form : Identifiable {

}
