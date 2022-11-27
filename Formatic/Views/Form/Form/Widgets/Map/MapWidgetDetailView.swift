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
    
    @EnvironmentObject var formModel: FormModel
    @ObservedObject var mapWidget: MapWidget
    @State var coordinateType: CoordinateType
    @State var localCoordinateRegion: MKCoordinateRegion
    
    init(mapWidget: MapWidget, coordinateType: CoordinateType = .latLon, localCoordinateRegion: MKCoordinateRegion) {
        self.mapWidget = mapWidget
        self._coordinateType = State(initialValue: coordinateType)
        self._localCoordinateRegion = State(initialValue: localCoordinateRegion)
    }
    
    var body: some View {
        
        VStack {
            
            AddAnnotationsView(mapWidget: mapWidget, localCoordinateRegion: $localCoordinateRegion, coordinateType: $coordinateType)
                .padding(.horizontal)
            
            MapView(mapWidget: mapWidget, localCoordinateRegion: $localCoordinateRegion)
                .overlay {
                    Image(systemName: Constants.scopeIconName)
                        .opacity(coordinateType == .center ? 1 : 0)
                }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(mapWidget.title ?? "")
    }
}

struct MapWidgetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            MapWidgetDetailView(mapWidget: dev.mapWidget, localCoordinateRegion: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: dev.mapWidget.coordinateRegionCenterLat, longitude: dev.mapWidget.coordinateRegionCenterLon), span: MKCoordinateSpan(latitudeDelta: dev.mapWidget.coordinateSpanLatDelta, longitudeDelta: dev.mapWidget.coordinateSpanLonDelta)))
                .environmentObject(FormModel())
        }
    }
}
