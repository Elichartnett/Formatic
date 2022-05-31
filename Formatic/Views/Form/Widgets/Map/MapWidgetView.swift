//
//  MapWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI
import MapKit

// Preview of map shown in form section
struct MapWidgetView: View {
    
    @ObservedObject var mapWidget: MapWidget
    @Binding var locked: Bool
    @State var title: String = ""
    @State var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.0902, longitude: -95.7129), span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))
    
    var body: some View {
        
        HStack {
            InputBox(placeholder: "Title", text: $title)
                .titleFrameStyle(locked: $locked)
                .onChange(of: title) { _ in
                    mapWidget.title = title
                }
                .onAppear {
                    title = mapWidget.title ?? ""
                }
            
            NavigationLink {
                MapWidgetDetailView(mapWidget: mapWidget)
            } label: {
                MapView(mapWidget: mapWidget, coordinateRegion: $coordinateRegion)
            }
            .WidgetFrameStyle()
        }
    }
}

struct MapWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        MapWidgetView(mapWidget: dev.mapWidget, locked: .constant(false))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
