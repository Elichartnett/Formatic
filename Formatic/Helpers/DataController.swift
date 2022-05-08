//
//  DataController.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/27/22.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    
    static let shared = DataController()
    
    @Published var container = NSPersistentContainer(name: "Form Container")
    
    private init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error)")
            }
        }
    }
    
    static func saveMOC() {
        do {
            try DataController.shared.container.viewContext.save()
        }
        catch {
            print("Could not save managed object context: \(error)")
        }
    }
}
