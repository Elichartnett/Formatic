//
//  PhotoLibraryWidget+CoreDataProperties.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/27/22.
//
//

import Foundation
import CoreData


extension PhotoLibraryWidget {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoLibraryWidget> {
        return NSFetchRequest<PhotoLibraryWidget>(entityName: "PhotoLibraryWidget")
    }
    
    @NSManaged public var showTitles: Bool
    @NSManaged public var photoWidgets: NSSet?
    
    /// PhotoLibrary  convenience init
    convenience init(title: String?, position: Int, showTitles: Bool = false) {
        self.init(title: title, position: position, type: WidgetType.photoLibraryWidget.rawValue)
        self.showTitles = showTitles
    }
}

// MARK: Generated accessors for photoWidgets
extension PhotoLibraryWidget {

    @objc(addPhotoWidgetsObject:)
    @NSManaged public func addToPhotoWidgets(_ value: PhotoWidget)

    @objc(removePhotoWidgetsObject:)
    @NSManaged public func removeFromPhotoWidgets(_ value: PhotoWidget)

    @objc(addPhotoWidgets:)
    @NSManaged public func addToPhotoWidgets(_ values: NSSet)

    @objc(removePhotoWidgets:)
    @NSManaged public func removeFromPhotoWidgets(_ values: NSSet)

}
