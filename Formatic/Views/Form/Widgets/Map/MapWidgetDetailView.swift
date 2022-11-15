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
    
    @Environment(\.colorScheme) var colorScheme
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
                    Image(systemName: Strings.scopeIconName)
                        .opacity(coordinateType == .center ? 1 : 0)
                }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(mapWidget.title ?? "")
        .background {
            if colorScheme == .light {
                Color(uiColor: .systemGray6).ignoresSafeArea()
            }
            else {
                Color.black.ignoresSafeArea()
            }
        }
    }
}

struct MapWidgetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            MapWidgetDetailView(mapWidget: dev.mapWidget, localCoordinateRegion: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: dev.mapWidget.coordinateRegionCenterLat, longitude: dev.mapWidget.coordinateRegionCenterLon), span: MKCoordinateSpan(latitudeDelta: dev.mapWidget.coordinateSpanLatDelta, longitudeDelta: dev.mapWidget.coordinateSpanLonDelta)))
        }
    }
}
