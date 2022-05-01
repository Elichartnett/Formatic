//
//  ContentView.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/26/22.
//

import SwiftUI

struct Home: View {
    
    var body: some View {
        
        // List of all created forms
        FormListView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environment(\.managedObjectContext, DataController.shared.container.viewContext)
    }
}
