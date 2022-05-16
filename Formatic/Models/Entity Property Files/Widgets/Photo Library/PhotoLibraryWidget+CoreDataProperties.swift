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
    @NSManaged public var photos: NSSet?
    
    public var photosArray: [PhotoWidget] {
        let set = photos as? Set<PhotoWidget> ?? []
        return set.sorted { lhs, rhs in
            lhs.position < rhs.position
        }
    }
    
    /// PhotoLibrary  convenience init
    convenience init(title: String?, position: Int, showTitles: Bool = false) {
        self.init(title: title, position: position, type: WidgetType.photoLibraryWidget.rawValue)
        self.showTitles = showTitles
    }
}

// MARK: Generated accessors for photos
extension PhotoLibraryWidget {
    
    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: PhotoWidget)
    
    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: PhotoWidget)
    
    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)
    
    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)
    
}
