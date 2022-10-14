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
    
    @Published var container = NSPersistentContainer(name: "Form Container")
    
    private init() {
        loadPersistentStores()
    }
    
    func loadPersistentStores() {
        container.loadPersistentStores { description, error in
            if let _ = error {
                DataControllerModel.failed = true
            }
            else {
                DataControllerModel.failed = false
            }
        }
    }
    
    static func saveMOC() throws {
        do {
            if DataControllerModel.shared.container.viewContext.hasChanges {
                try DataControllerModel.shared.container.viewContext.save()
            }
        }
        catch {
            throw FormError.saveError
        }
    }
}
