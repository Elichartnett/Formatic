//
//  MapWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI
import MapKit

struct MapWidgetView: View {
    
    @EnvironmentObject var formModel: FormModel
    @Environment(\.editMode) var editMode
    
    @ObservedObject var mapWidget: MapWidget
    @Binding var locked: Bool
    @State var title: String
    @State var reconfigureWidget = false
    @State var widgetViewPreviewSize = CGSize.zero
    @State var localCoordinateRegion = Constants.defaultMKCoordinateRegion
    var forPDF: Bool
    @State var showReconfigureButton = false
    
    init(mapWidget: MapWidget, locked: Binding<Bool>, forPDF: Bool) {
        self.mapWidget = mapWidget
        self._locked = locked
        self._title = State(initialValue: mapWidget.title ?? Constants.emptyString)
        self.forPDF = forPDF
        self._localCoordinateRegion = State(initialValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: mapWidget.coordinateRegionCenterLat, longitude: mapWidget.coordinateRegionCenterLon), span: MKCoordinateSpan(latitudeDelta: mapWidget.coordinateSpanLatDelta, longitudeDelta: mapWidget.coordinateSpanLonDelta)))
    }
    
    var body: some View {
        
        let baseView = Group {
            
            Group {
                
                HStack {
                    InputBox(placeholder: Strings.titleLabel, text: $title)
                        .titleFrameStyle(locked: $locked)
                        .onChange(of: title) { _ in
                            mapWidget.title = title
                        }
                    
                    if formModel.isPhone {
                        ReconfigureWidgetButton(reconfigureWidget: $reconfigureWidget)
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
                                        mapWidget.updatePreviewSnapshot(size: widgetViewPreviewSize)
                                    }
                            }
                            else {
                                Image(uiImage: UIImage(data: mapWidget.widgetViewPreview) ?? UIImage())
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
                    }
                    .widgetFrameStyle(height: .large)
                }
                .disabled(editMode?.wrappedValue == .active)
                
                if !formModel.isPhone && editMode?.wrappedValue == .active {
                    ReconfigureWidgetButton(reconfigureWidget: $reconfigureWidget)
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
            VStack(alignment: .leading, spacing: Constants.stackSpacingConstant) {
                baseView
            }
        }
        else {
            HStack(spacing: Constants.stackSpacingConstant) {
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
