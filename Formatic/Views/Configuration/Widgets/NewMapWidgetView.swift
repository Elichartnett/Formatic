//
//  NewMapWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/3/22.
//

import SwiftUI
import MapKit

// In new widget sheet to configure new MapWidget
struct NewMapWidgetView: View {
    
    @EnvironmentObject var formModel: FormModel
    
    @Binding var newWidgetType: WidgetType?
    @Binding var title: String
    @State var section: Section
    @State var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.0902, longitude: -95.7129), span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))
    
    var body: some View {
        
        VStack {
            
            Text("Form Preview")
                .font(.title)
            
            Map(coordinateRegion: $coordinateRegion, interactionModes: .all, showsUserLocation: false, userTrackingMode: .none)
                .WidgetPreviewStyle()
            
            Button {
                
                let mapWidget = MapWidget(title: title, position: formModel.numberOfWidgetsInSection(section: section), coordinateRegionCenterLat: coordinateRegion.center.latitude, coordinateRegionCenterLon: coordinateRegion.center.longitude, coordinateSpanLatDelta: coordinateRegion.span.latitudeDelta, coordinateSpanLonDelta: coordinateRegion.span.longitudeDelta)
                
                withAnimation {
                    section.addToWidgets(mapWidget)
                    DataController.saveMOC()
                }
                newWidgetType = nil
            } label: {
                SubmitButton(isValid: .constant(true))
            }
        }
        .padding()
    }
}

struct NewMapWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        NewMapWidgetView(newWidgetType: .constant(.mapWidget), title: .constant(dev.mapWidget.title!), section: dev.section)
    }
}
