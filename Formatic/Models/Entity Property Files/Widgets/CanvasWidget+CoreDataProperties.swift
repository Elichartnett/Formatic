//
//  CanvasWidget+CoreDataProperties.swift
//  Formatic
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
    
    @NSManaged public var image: Data?
    @NSManaged public var pkDrawing: Data?
    @NSManaged public var preview: Data?
    
    /// CanvasWidget  convenience init
    convenience init(title: String?, position: Int) {
        self.init(title: title, position: position, type: WidgetType.canvasWidget.rawValue)
    }
}
