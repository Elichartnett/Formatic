//
//  PhotoWidget+CoreDataProperties.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/14/22.
//
//

import Foundation
import CoreData


extension PhotoWidget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoWidget> {
        return NSFetchRequest<PhotoWidget>(entityName: "PhotoWidget")
    }

    @NSManaged public var photo: Data?
    @NSManaged public var library: PhotoLibraryWidget?

    /// PhotoWidget  convenience init
    convenience init(title: String?, position: Int, photo: Data?) {
        self.init(title: title, position: position, type: WidgetType.photoWidget.rawValue)
        self.photo = photo
    }
}
