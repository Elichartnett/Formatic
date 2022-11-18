//
//  DataController.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/27/22.
//

import Foundation
import CoreData

class DataControllerModel: ObservableObject {
    
    static let shared = DataControllerModel()
    
    static var failed: Bool?
    
    @Published var container = NSPersistentCloudKitContainer(name: Strings.formContainerFileName)
//    @Published var recentlyDeletedContainer = NSPersistentCloudKitContainer(name: Strings.formContainerFileName + "-RecentlyDeleted")
    
    private init() {
        setupContainers()
    }
    
    func setupContainers() {
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
//        recentlyDeletedContainer.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy

        container.viewContext.automaticallyMergesChangesFromParent = true
//        recentlyDeletedContainer.viewContext.automaticallyMergesChangesFromParent = true
        
        let description = container.persistentStoreDescriptions.first
        description?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description?.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
//        let recentlyDeleteddescription = container.persistentStoreDescriptions.first
//        recentlyDeleteddescription?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
//        recentlyDeleteddescription?.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        container.loadPersistentStores { description, error in
            if let _ = error {
                DataControllerModel.failed = true
            }
            else {
                DataControllerModel.failed = false
            }
        }
        
//        recentlyDeletedContainer.loadPersistentStores { description, error in
//            if let _ = error {
//                DataControllerModel.failed = true
//            }
//            else {
//                DataControllerModel.failed = false
//            }
//        }
    }
    
    static func saveMOC() throws {
        do {
            if DataControllerModel.shared.container.viewContext.hasChanges {
                try DataControllerModel.shared.container.viewContext.save()
            }
//            if DataControllerModel.shared.recentlyDeletedContainer.viewContext.hasChanges {
//                try DataControllerModel.shared.recentlyDeletedContainer.viewContext.save()
//            }
        }
        catch {
            throw FormError.saveError
        }
    }
}
