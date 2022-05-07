//
//  MapWidgetView.swift
// Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct MapWidgetView: View {
    
    @ObservedObject var mapWidget: MapWidget
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct MapWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        MapWidgetView(mapWidget: dev.mapWidget)
    }
}
