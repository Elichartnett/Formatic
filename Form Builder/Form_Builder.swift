//
//  Form_BuilderApp.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/26/22.
//

import SwiftUI

@main
struct Form_Builder: App {
    var body: some Scene {
        WindowGroup {
            Home()
                .environment(\.managedObjectContext, DataController.shared.container.viewContext)
                .environmentObject(FormModel())
        }
    }
}
