//
//  ContentView.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/26/22.
//

import SwiftUI

struct Home: View {
    
    var body: some View {
        
        TabView {
            
            // First tab - Used to edit a form
            FormEditorView()
                .tabItem {
                    Label {
                        Text("Editor")
                    } icon: {
                        Image(systemName: "gearshape")
                    }
                }
            
            // Second tab - List of all created forms
            FormListView()
                .tabItem {
                    Label {
                        Text("Forms")
                    } icon: {
                        Image(systemName: "list.bullet")
                    }
                }
            
        }.tabViewStyle(.automatic)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environment(\.managedObjectContext, DataController.shared.container.viewContext)
            .environmentObject(FormModel())
    }
}
