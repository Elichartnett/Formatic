//
//  PhotoLibraryWidget+CoreDataProperties.swift
//  Form Builder
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
    
    @NSManaged public var photos: NSSet?
    
    public var annotationsArray: [Photo] {
        let set = photos as? Set<Photo> ?? []
        return Array(set)
    }
    
    /// PhotoLibrary  convenience init
    convenience init(title: String?) {
        self.init(title: title, entity: "PhotoLibraryWidget")
    }
}

// MARK: Generated accessors for photos
extension PhotoLibraryWidget {
    
    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)
    
    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)
    
    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)
    
    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)
    
}
