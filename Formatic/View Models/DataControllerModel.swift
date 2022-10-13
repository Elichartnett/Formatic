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
    
    @Published var container = NSPersistentContainer(name: "Form Container")
    
    private init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                // TODO: handle error
                print("Core Data failed to load: \(error)")
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
