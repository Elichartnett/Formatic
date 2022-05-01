//
//  MapWidget+CoreDataProperties.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/29/22.
//
//

import Foundation
import CoreData


extension MapWidget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MapWidget> {
        return NSFetchRequest<MapWidget>(entityName: "MapWidget")
    }

    @NSManaged public var annotations: NSSet?

    public var annotationsArray: [Annotation] {
        let set = annotations as? Set<Annotation> ?? []
        return Array(set)
    }
    
    /// MapWidget  convenience init
    convenience init(title: String?, position: Double) {
        self.init(title: title, position: position, type: "MapWidget")
    }
}

// MARK: Generated accessors for annotations
extension MapWidget {

    @objc(addAnnotationsObject:)
    @NSManaged public func addToAnnotations(_ value: Annotation)

    @objc(removeAnnotationsObject:)
    @NSManaged public func removeFromAnnotations(_ value: Annotation)

    @objc(addAnnotations:)
    @NSManaged public func addToAnnotations(_ values: NSSet)

    @objc(removeAnnotations:)
    @NSManaged public func removeFromAnnotations(_ values: NSSet)

}
