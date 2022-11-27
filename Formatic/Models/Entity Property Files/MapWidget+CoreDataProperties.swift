//
//  MapWidget+CoreDataProperties.swift
//  Formatic
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

    @NSManaged public var coordinateRegionCenterLat: Double
    @NSManaged public var coordinateRegionCenterLon: Double
    @NSManaged public var coordinateSpanLatDelta: Double
    @NSManaged public var coordinateSpanLonDelta: Double
    @NSManaged public var widgetViewPreview: Data

    @NSManaged public var annotations: NSSet?
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
