//
//  MapView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/12/22.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @ObservedObject var mapWidget: MapWidget
    @FetchRequest var annotations: FetchedResults<Annotation>
    @Binding var localCoordinateRegion: MKCoordinateRegion
    
    init(mapWidget: MapWidget, localCoordinateRegion: Binding<MKCoordinateRegion>) {
        self.mapWidget = mapWidget
        self._annotations = FetchRequest<Annotation>(sortDescriptors: [], predicate: NSPredicate(format: Constants.predicateMapWidgetEqualTo, mapWidget))
        self._localCoordinateRegion = localCoordinateRegion
    }
    
    var body: some View {
        
        Map(coordinateRegion: $localCoordinateRegion, interactionModes: .all, showsUserLocation: true, userTrackingMode: .constant(.none), annotationItems: annotations) { annotation in
            MapMarker(coordinate: CLLocationCoordinate2D(latitude: annotation.latitude, longitude: annotation.longitude))
        }
        .onAppear {
            let manager = CLLocationManager()
            switch manager.authorizationStatus {
            case .authorizedAlways:
                manager.startUpdatingLocation()
            case .authorizedWhenInUse:
                manager.startUpdatingLocation()
            case .restricted:
                break
            case .denied:
                break
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            @unknown default:
                fatalError(Constants.unknownDefault)
            }
        }
        .ignoresSafeArea()
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(mapWidget: dev.mapWidget, localCoordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: dev.mapWidget.coordinateRegionCenterLat, longitude: dev.mapWidget.coordinateRegionCenterLon), span: MKCoordinateSpan(latitudeDelta: dev.mapWidget.coordinateSpanLatDelta, longitudeDelta: dev.mapWidget.coordinateSpanLonDelta))))
    }
}
