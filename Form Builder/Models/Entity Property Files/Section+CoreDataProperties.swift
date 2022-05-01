//
//  Section+CoreDataProperties.swift
//  Form Builder
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
    @NSManaged public var title: String?
    @NSManaged public var widgets: NSSet?
    @NSManaged public var form: Form?
    
    /// Section convenience init
    convenience init(id: UUID = UUID(), title: String?) {
        self.init(context: DataController.shared.container.viewContext)
        self.id = id
        self.title = title
    }
    
    var widgetsArray: [Widget] {
        let set = widgets as? Set<Widget> ?? []
        return set.sorted { rhs, lhs in
            rhs.title ?? "" < lhs.title ?? ""
        }
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

extension Section : Identifiable {
    
}
