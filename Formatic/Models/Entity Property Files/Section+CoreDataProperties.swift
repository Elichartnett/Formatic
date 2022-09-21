//
//  Section+CoreDataProperties.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/28/22.
//
//

import Foundation
import CoreData


extension Section {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Section> {
        return NSFetchRequest<Section>(entityName: "Section")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var position: Int16
    @NSManaged public var title: String?
    @NSManaged public var form: Form?
    @NSManaged public var widgets: Set<Widget>?
    
    /// Section convenience init
    convenience init(id: UUID = UUID(), position: Int, title: String?) {
        self.init(context: DataController.shared.container.viewContext)
        self.id = id
        self.position = Int16(position)
        self.title = title
    }
}

// MARK: Generated accessors for widgets
extension Section {

    @objc(addWidgetsObject:)
    @NSManaged public func addToWidgets(_ value: Widget)

    @objc(removeWidgetsObject:)
    @NSManaged public func removeFromWidgets(_ value: Widget)

    @objc(addWidgets:)
    @NSManaged public func addToWidgets(_ values: NSSet)

    @objc(removeWidgets:)
    @NSManaged public func removeFromWidgets(_ values: NSSet)

}
