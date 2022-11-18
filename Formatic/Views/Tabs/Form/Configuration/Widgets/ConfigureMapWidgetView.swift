//
//  ConfigureMapWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/3/22.
//

import SwiftUI
import MapKit
import FirebaseAnalytics

// In new widget sheet to configure new MapWidget
struct ConfigureMapWidgetView: View {
    @EnvironmentObject var formModel: FormModel
    @Environment(\.dismiss) var dismiss
    @State var mapWidget: MapWidget?
    @Binding var title: String
    @State var section: Section
    @State var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.0902, longitude: -95.7129), span: MKCoordinateSpan(latitudeDelta: 90, longitudeDelta: 90))
    var widgetViewPreviewSize = CGSize.zero
    
    var body: some View {
        
        VStack {
            
            Group {
                if let mapWidget {
                    MapView(mapWidget: mapWidget, localCoordinateRegion: $coordinateRegion)
                }
                else {
                    Map(coordinateRegion: $coordinateRegion, interactionModes: .all, showsUserLocation: false, userTrackingMode: .none)
                }
            }
            .WidgetFrameStyle(height: .large)
            
            Button {
                if let mapWidget {
                    mapWidget.coordinateRegionCenterLat = coordinateRegion.center.latitude
                    mapWidget.coordinateRegionCenterLon = coordinateRegion.center.longitude
                    mapWidget.coordinateSpanLatDelta = coordinateRegion.span.latitudeDelta
                    mapWidget.coordinateSpanLonDelta = coordinateRegion.span.longitudeDelta
                    formModel.updateMapWidgetSnapshot(size: widgetViewPreviewSize, mapWidget: mapWidget)
                    withAnimation {
                        section.addToWidgets(mapWidget)
                    }
                }
                else {
                    let mapWidget = MapWidget(title: title, position: formModel.numberOfWidgetsInSection(section: section), coordinateRegionCenterLat: coordinateRegion.center.latitude, coordinateRegionCenterLon: coordinateRegion.center.longitude, coordinateSpanLatDelta: coordinateRegion.span.latitudeDelta, coordinateSpanLonDelta: coordinateRegion.span.longitudeDelta)
                    withAnimation {
                        section.addToWidgets(mapWidget)
                    }
                    Analytics.logEvent(Strings.analyticsCreateMapWidgetEvent, parameters: nil)
                }
                dismiss()
            } label: {
                SubmitButton(isValid: .constant(true))
            }
        }
        .onAppear {
            if let mapWidget {
                coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: mapWidget.coordinateRegionCenterLat, longitude: mapWidget.coordinateRegionCenterLon), span: MKCoordinateSpan(latitudeDelta: mapWidget.coordinateSpanLatDelta, longitudeDelta: mapWidget.coordinateSpanLonDelta))
            }
        }
    }
}

struct ConfigureMapWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureMapWidgetView(title: .constant(dev.mapWidget.title!), section: dev.section)
    }
}
