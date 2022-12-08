//
//  CanvasWidget+CoreDataProperties.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/27/22.
//

import Foundation
import CoreData

extension CanvasWidget {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CanvasWidget> {
        return NSFetchRequest<CanvasWidget>(entityName: "CanvasWidget")
    }
    
    @NSManaged public var image: Data?
    @NSManaged public var pkDrawing: Data?
    @NSManaged public var widgetViewPreview: Data?
}
