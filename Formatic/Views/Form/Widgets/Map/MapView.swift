//
//  MapView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/12/22.
//

import SwiftUI
import MapKit

// Shows MapWidget annotations
struct MapView: View {
    
    @ObservedObject var mapWidget: MapWidget
    @Binding var coordinateRegion: MKCoordinateRegion
    @FetchRequest var annotations: FetchedResults<Annotation>
    
    init(mapWidget: MapWidget, coordinateRegion: Binding<MKCoordinateRegion>) {
        self.mapWidget = mapWidget
        self._coordinateRegion = coordinateRegion
        self._annotations = FetchRequest<Annotation>(sortDescriptors: [], predicate: NSPredicate(format: "mapWidget == %@", mapWidget))
    }
    
    var body: some View {
        
        Map(coordinateRegion: $coordinateRegion, interactionModes: .all, showsUserLocation: true, userTrackingMode: .constant(.none), annotationItems: annotations) { annotation in
            MapMarker(coordinate: CLLocationCoordinate2D(latitude: annotation.latitude, longitude: annotation.longitude))
        }
        .ignoresSafeArea()
        .onAppear {
            let manager = CLLocationManager()
            switch manager.authorizationStatus {
            case .authorizedAlways:
                manager.startUpdatingLocation()
            case .authorizedWhenInUse:
                manager.startUpdatingLocation()
            case .restricted:
                print("Location restricted")
            case .denied:
                print("Location denied")
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
                print("Location not determined")
            @unknown default:
                fatalError("Unkown default in map")
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(mapWidget: dev.mapWidget, coordinateRegion: .constant(dev.coordinateRegion))
    }
}
