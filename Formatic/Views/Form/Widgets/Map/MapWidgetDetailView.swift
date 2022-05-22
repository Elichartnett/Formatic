//
//  MapWidgetDetailView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/12/22.
//

import SwiftUI
import MapKit
import UTMConversion

// Full map view to plot annotations with
struct MapWidgetDetailView: View {
    
    @ObservedObject var mapWidget: MapWidget
    @State var coordinateType: CoordinateType = .latLon
    @State var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.0902, longitude: -95.7129), span: MKCoordinateSpan(latitudeDelta: 70, longitudeDelta: 70))
    
    var body: some View {
        
        VStack {
            
            AddAnnotationsView(mapWidget: mapWidget, coordinateType: $coordinateType, coordinateRegion: $coordinateRegion)
                .padding()
            
            ZStack {
                MapView(mapWidget: mapWidget, coordinateRegion: $coordinateRegion)
                
                if coordinateType == .center {
                    withAnimation {
                        Image(systemName: "scope")
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(mapWidget.title ?? "")
    }
}

struct MapWidgetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MapWidgetDetailView(mapWidget: dev.mapWidget)
    }
}
