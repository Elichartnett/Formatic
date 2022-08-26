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
    @ObservedObject var mapWidget: MapWidget
    @Binding var locked: Bool
    @State var title: String
    @State var labelWidth: Double = 1
    
    init(mapWidget: MapWidget, locked: Binding<Bool>) {
        self.mapWidget = mapWidget
        self._locked = locked
        self.title = mapWidget.title ?? ""
    }
    
    var body: some View {
        
        HStack {
            InputBox(placeholder: "Title", text: $title)
                .titleFrameStyle(locked: $locked)
                .onChange(of: title) { _ in
                    mapWidget.title = title
                }
            
            NavigationLink {
                MapWidgetDetailView(mapWidget: mapWidget, coordinateRegion: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: mapWidget.coordinateRegionCenterLat, longitude: mapWidget.coordinateRegionCenterLon), span: MKCoordinateSpan(latitudeDelta: mapWidget.coordinateSpanLatDelta, longitudeDelta: mapWidget.coordinateSpanLonDelta)), labelWidth: labelWidth)
            } label: {
                GeometryReader { proxy in
                    Image(uiImage: UIImage(data: mapWidget.widgetViewPreview) ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .onAppear(perform: {
                            if mapWidget.widgetViewPreview == Data() {
                                formModel.updateMapWidgetSnapshot(size: proxy.size, mapWidget: mapWidget)
                                self.labelWidth = proxy.size.width
                            }
                        })
                        .onChange(of: proxy.size) { _ in
                            withAnimation {
                                self.labelWidth = proxy.size.width
                                formModel.updateMapWidgetSnapshot(size: proxy.size, mapWidget: mapWidget)
                            }
                        }
                }
            }
            .WidgetPreviewStyle()
        }
    }
}

struct MapWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        MapWidgetView(mapWidget: dev.mapWidget, locked: .constant(false))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
