//
//  MapWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI
import MapKit

struct MapWidgetView: View {
    
    @ObservedObject var mapWidget: MapWidget
    @Binding var locked: Bool
    @State var title: String = ""
    @State var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.0902, longitude: -95.7129), span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))
    
    var body: some View {
        
        HStack {
            InputBox(placeholder: "Title", text: $title)
                .titleFrameStyle()
                .onChange(of: title) { _ in
                    mapWidget.title = title
                }
                .onAppear {
                    title = mapWidget.title ?? ""
                }
                .disabled(locked)
            
            MapView(mapWidget: mapWidget, coordinateRegion: $coordinateRegion)
                .frame(height: 200)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.secondary, lineWidth: 2)
                )
        }
    }
}

struct MapWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        MapWidgetView(mapWidget: dev.mapWidget, locked: .constant(false))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
