//
//  CanvasWidget+CoreDataProperties.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/27/22.
//
//

import Foundation
import CoreData


extension CanvasWidget {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CanvasWidget> {
        return NSFetchRequest<CanvasWidget>(entityName: "CanvasWidget")
    }
    
    @NSManaged public var pkCanvas: Data?
    @NSManaged public var imageView: Data?
    @NSManaged public var image: Data?
    @NSManaged public var preview: Data?
    
}
