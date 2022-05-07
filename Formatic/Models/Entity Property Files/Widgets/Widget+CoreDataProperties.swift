//
//  Widget+CoreDataProperties.swift
// Formatic
//
//  Created by Eli Hartnett on 4/30/22.
//
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
    
    /// Widget convenience init
    convenience init (title: String?, position: Int, type: String) {
        self.init(entity: NSEntityDescription.entity(forEntityName: type, in: DataController.shared.container.viewContext) ?? NSEntityDescription(), insertInto: DataController.shared.container.viewContext)
        self.id = UUID()
        self.position = Int16(position)
        self.title = title
        self.type = type
    }
}

extension Widget : Identifiable {

}
