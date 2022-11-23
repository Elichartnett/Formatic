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
    @State var localCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.0902, longitude: -95.7129), span: MKCoordinateSpan(latitudeDelta: 90, longitudeDelta: 90))
    var forPDF: Bool
    
    init(mapWidget: MapWidget, locked: Binding<Bool>, forPDF: Bool) {
        self.mapWidget = mapWidget
        self._locked = locked
        self._title = State(initialValue: mapWidget.title ?? "")
        self.forPDF = forPDF
        self._localCoordinateRegion = State(initialValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: mapWidget.coordinateRegionCenterLat, longitude: mapWidget.coordinateRegionCenterLon), span: MKCoordinateSpan(latitudeDelta: mapWidget.coordinateSpanLatDelta, longitudeDelta: mapWidget.coordinateSpanLonDelta)))
    }
    
    var body: some View {
        
        let baseView = Group {
            
            let reconfigureButton = Button {
                reconfigureWidget = true
            } label: {
                Image(systemName: Strings.editIconName)
                    .customIcon()
                    .opacity(editMode?.wrappedValue == .active ? 1 : 0)
            }
                .disabled(editMode?.wrappedValue == .inactive)
                .transition(.asymmetric(insertion: .push(from: .trailing), removal: .push(from: .leading)))
            
            Group {
                
                HStack {
                    InputBox(placeholder: Strings.titleLabel, text: $title)
                        .titleFrameStyle(locked: $locked)
                        .onChange(of: title) { _ in
                            mapWidget.title = title
                        }
                    
                    if formModel.isPhone {
                        reconfigureButton
                    }
                }
                
                Group {
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
                    .WidgetFrameStyle(height: .large)
                }
                .disabled(editMode?.wrappedValue == .active)
                
                if !formModel.isPhone && editMode?.wrappedValue == .active {
                    reconfigureButton
                }
            }
            .sheet(isPresented: $reconfigureWidget) {
                localCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: mapWidget.coordinateRegionCenterLat, longitude: mapWidget.coordinateRegionCenterLon), span: MKCoordinateSpan(latitudeDelta: mapWidget.coordinateSpanLatDelta, longitudeDelta: mapWidget.coordinateSpanLonDelta))
            } content: {
                ConfigureMapWidgetView(mapWidget: mapWidget, title: $title, section: mapWidget.section!, widgetViewPreviewSize: widgetViewPreviewSize)
                    .padding()
            }
        }
        
        if formModel.isPhone {
            VStack(alignment: .leading, spacing: FormModel.spacingConstant) {
                baseView
            }
        }
        else {
            HStack(spacing: FormModel.spacingConstant) {
                baseView
            }
        }
    }
}

struct MapWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        MapWidgetView(mapWidget: dev.mapWidget, locked: .constant(false), forPDF: false)
            .previewInterfaceOrientation(.landscapeLeft)
            .environmentObject(FormModel())
    }
}
