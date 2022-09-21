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
    @State var labelWidth: Double = 1
    @State var reconfigureWidget = false
    @State var widgetViewPreviewSize = CGSize.zero
    
    init(mapWidget: MapWidget, locked: Binding<Bool>) {
        self.mapWidget = mapWidget
        self._locked = locked
        self._title = State(initialValue: mapWidget.title ?? "")
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
                            widgetViewPreviewSize = proxy.size
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
            .disabled(editMode?.wrappedValue == .active)
            
            Button {
                reconfigureWidget = true
            } label: {
                if editMode?.wrappedValue == .active {
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .foregroundColor(.black)
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                }
            }
            .disabled(editMode?.wrappedValue == .inactive)
        }
        .sheet(isPresented: $reconfigureWidget) {
            ConfigureMapWidgetView(mapWidget: mapWidget, title: $title, section: mapWidget.section!, widgetViewPreviewSize: widgetViewPreviewSize)
                .padding()
        }
    }
}

struct MapWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        MapWidgetView(mapWidget: dev.mapWidget, locked: .constant(false))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
