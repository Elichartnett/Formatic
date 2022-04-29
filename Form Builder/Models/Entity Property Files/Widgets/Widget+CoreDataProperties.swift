//
//  Widget+CoreDataProperties.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/28/22.
//
//

import Foundation
import CoreData


extension Widget {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Widget> {
        return NSFetchRequest<Widget>(entityName: "Widget")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var title: String?
    
    convenience init(id: UUID, title: String?) {
        self.init(context: DataController.shared.container.viewContext)
        self.id = id
        self.title = title
    }
}

extension Widget : Identifiable {
    
}
