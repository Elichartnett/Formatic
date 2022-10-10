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
    
    @EnvironmentObject var formModel: FormModel
    @Environment(\.editMode) var editMode
    @ObservedObject var mapWidget: MapWidget
    @Binding var locked: Bool
    @State var title: String
    @State var reconfigureWidget = false
    @State var widgetViewPreviewSize = CGSize.zero
    @State var localCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.0902, longitude: -95.7129), span: MKCoordinateSpan(latitudeDelta: 70, longitudeDelta: 70))
    var forPDF: Bool
    
    init(mapWidget: MapWidget, locked: Binding<Bool>, forPDF: Bool) {
        self.mapWidget = mapWidget
        self._locked = locked
        self._title = State(initialValue: mapWidget.title ?? "")
        self.forPDF = forPDF
        self._localCoordinateRegion = State(initialValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: mapWidget.coordinateRegionCenterLat, longitude: mapWidget.coordinateRegionCenterLon), span: MKCoordinateSpan(latitudeDelta: mapWidget.coordinateSpanLatDelta, longitudeDelta: mapWidget.coordinateSpanLonDelta)))
    }
    
    var body: some View {
        
        HStack {
            InputBox(placeholder: "Title", text: $title)
                .titleFrameStyle(locked: $locked)
                .onChange(of: title) { _ in
                    mapWidget.title = title
                }
            
            NavigationLink {
                MapWidgetDetailView(mapWidget: mapWidget, localCoordinateRegion: localCoordinateRegion)
            } label: {
                GeometryReader { proxy in
                    if !forPDF {
                        MapView(mapWidget: mapWidget, localCoordinateRegion: $localCoordinateRegion)
                            .onAppear {
                                widgetViewPreviewSize = proxy.size
                                formModel.updateMapWidgetSnapshot(size: proxy.size, mapWidget: mapWidget)
                            }
                    }
                    else {
                        Image(uiImage: UIImage(data: mapWidget.widgetViewPreview) ?? UIImage())
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
            .WidgetPreviewStyle()
            .disabled(editMode?.wrappedValue == .active)
            
            Button {
                reconfigureWidget = true
            } label: {
                if editMode?.wrappedValue == .active {
                    Image(systemName: "slider.horizontal.3")
                        .customIcon()
                }
            }
            .disabled(editMode?.wrappedValue == .inactive)
        }
        .sheet(isPresented: $reconfigureWidget) {
            localCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: mapWidget.coordinateRegionCenterLat, longitude: mapWidget.coordinateRegionCenterLon), span: MKCoordinateSpan(latitudeDelta: mapWidget.coordinateSpanLatDelta, longitudeDelta: mapWidget.coordinateSpanLonDelta))
        } content: {
            ConfigureMapWidgetView(mapWidget: mapWidget, title: $title, section: mapWidget.section!, widgetViewPreviewSize: widgetViewPreviewSize)
                .padding()
        }
    }
}

struct MapWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        MapWidgetView(mapWidget: dev.mapWidget, locked: .constant(false), forPDF: false)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
