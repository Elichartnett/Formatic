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
    @State var coordinateType: CoordinateType = .latLon
    @State var coordinateRegion: MKCoordinateRegion
    var labelWidth: Double
    
    var body: some View {
        
        VStack {
            
            AddAnnotationsView(mapWidget: mapWidget, coordinateType: $coordinateType, coordinateRegion: $coordinateRegion)
                .padding()
            
            MapView(mapWidget: mapWidget, coordinateRegion: $coordinateRegion)
                .overlay {
                    Image(systemName: "scope")
                        .opacity(coordinateType == .center ? 1 : 0)
                }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(mapWidget.title ?? "")
        .onDisappear {
            withAnimation {
                formModel.updateMapWidgetSnapshot(size: CGSize(width: labelWidth, height: 200), mapWidget: mapWidget)
            }
        }
    }
}

struct MapWidgetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            MapWidgetDetailView(mapWidget: dev.mapWidget, coordinateRegion: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: dev.mapWidget.coordinateRegionCenterLat, longitude: dev.mapWidget.coordinateRegionCenterLon), span: MKCoordinateSpan(latitudeDelta: dev.mapWidget.coordinateSpanLatDelta, longitudeDelta: dev.mapWidget.coordinateSpanLonDelta)), labelWidth: 500)
        }
    }
}
