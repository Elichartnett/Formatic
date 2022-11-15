//
//  AddAnnotationsView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/11/22.
//

import SwiftUI
import UTMConversion
import MapKit

// View to add annoations to a MapWidget
struct AddAnnotationsView: View {
    
    @EnvironmentObject var formModel: FormModel
    @ObservedObject var mapWidget: MapWidget
    @Binding var localCoordinateRegion: MKCoordinateRegion
    @Binding var coordinateType: CoordinateType
    @State var latitude: String = ""
    @State var longitude: String = ""
    @State var validLatitude: Bool = false
    @State var validLongitude: Bool = false
    @State var easting: String = ""
    @State var northing: String = ""
    @State var zone: String = ""
    @State var hemisphere: UTMHemisphere = .northern
    @State var validEasting: Bool = false
    @State var validNorthing: Bool = false
    @State var validZone: Bool = false
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    var body: some View {
        
        let baseView = HStack {
            if coordinateType == .latLon {
                InputBox(placeholder: Strings.latitudeLabel, text: $latitude, inputType: .number, isValid: $validLatitude, numberRange: -90...90)
                    .titleFrameStyle(locked: .constant(false))
                InputBox(placeholder: Strings.longitudeLabel, text: $longitude, inputType: .number, isValid: $validLongitude, numberRange: -180...180)
                    .titleFrameStyle(locked: .constant(false))
            }
            else if coordinateType == .utm {
                InputBox(placeholder: Strings.eastingLabel, text: $easting, inputType: .number, isValid: $validEasting, numberRange: 166640...833360)
                    .titleFrameStyle(locked: .constant(false))
                InputBox(placeholder: Strings.northingLabel, text: $northing, inputType: .number, isValid: $validNorthing, numberRange: 1110400...9334080)
                    .titleFrameStyle(locked: .constant(false))
                InputBox(placeholder: Strings.zoneLabel, text: $zone, inputType: .number, isValid: $validZone, numberRange: 1...60)
                    .frame(width: 100)
                
                Picker(Strings.hemisphereLabel, selection: $hemisphere) {
                    Text(Strings.northernLabel)
                        .tag(UTMHemisphere.northern)
                    Text(Strings.southernLabel)
                        .tag(UTMHemisphere.southern)
                }
                .pickerStyle(.menu)
            }
            else if coordinateType == .center {
                VStack {
                    Text(Strings.latitudeLabel).bold().underline()
                    Text(formatter.string(from: localCoordinateRegion.center.latitude as NSNumber)!)
                }
                VStack {
                    Text(Strings.longitudeLabel).bold().underline()
                    Text(formatter.string(from: localCoordinateRegion.center.longitude as NSNumber)!)
                }
                
                VStack {
                    Text(Strings.eastingLabel).bold().underline()
                    Text(formatter.string(from: localCoordinateRegion.center.utmCoordinate().easting as NSNumber)!)
                }
                
                VStack {
                    Text(Strings.northingLabel).bold().underline()
                    Text(formatter.string(from: localCoordinateRegion.center.utmCoordinate().northing as NSNumber)!)
                }
                
                VStack {
                    Text(Strings.zoneLabel).bold().underline()
                    Text(formatter.string(from: localCoordinateRegion.center.utmCoordinate().zone as NSNumber)!)
                }
                
                VStack {
                    Text(Strings.hemisphereLabel).bold().underline()
                    Text(localCoordinateRegion.center.utmCoordinate().hemisphere == .northern ? Strings.northernLabel : Strings.southernLabel)
                }
            }
            
            Button {
                let annotation = Annotation(context: DataControllerModel.shared.container.viewContext)
                annotation.id = UUID()
                if coordinateType == .latLon {
                    annotation.latitude = Double(latitude)!
                    annotation.longitude = Double(longitude)!
                    latitude = ""
                    longitude = ""
                }
                else if coordinateType == .utm {
                    let utmCoordinate = UTMCoordinate(northing: Double(northing)!, easting: Double(easting)!, zone: UTMGridZone(zone)!, hemisphere: hemisphere).coordinate()
                    easting = ""
                    northing = ""
                    zone = ""
                    let latitude = utmCoordinate.latitude
                    let longitude = utmCoordinate.longitude
                    annotation.latitude = latitude
                    annotation.longitude = longitude
                }
                else if coordinateType == .center {
                    annotation.latitude = localCoordinateRegion.center.latitude
                    annotation.longitude = localCoordinateRegion.center.longitude
                }
                mapWidget.addToAnnotations(annotation)
            } label: {
                Image(systemName: Strings.plusIconName)
                Text(Strings.addPinLabel)
            }
            .disabled(coordinateType == .latLon ? !(validLatitude && validLongitude) : coordinateType == .utm ? !(validEasting && validNorthing && validZone) : false)
        }.animation(.default, value: coordinateType)
        
        VStack {
            
            Picker(Strings.coordinateTypePickerLabel, selection: $coordinateType) {
                ForEach(CoordinateType.allCases) { type in
                    Text(type.rawValue)
                        .tag(type)
                }
            }
            .pickerStyle(.segmented)
            
            if formModel.isPhone {
                ScrollView(.horizontal) {
                    baseView
                        .padding()
                        .scrollIndicators(.automatic)
                }
            }
            else {
                baseView
            }
        }
    }
}

struct AddAnnotationsView_Previews: PreviewProvider {
    static var previews: some View {
        AddAnnotationsView(mapWidget: dev.mapWidget, localCoordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: dev.mapWidget.coordinateRegionCenterLat, longitude: dev.mapWidget.coordinateRegionCenterLon), span: MKCoordinateSpan(latitudeDelta: dev.mapWidget.coordinateSpanLatDelta, longitudeDelta: dev.mapWidget.coordinateSpanLonDelta))), coordinateType: .constant(.latLon), latitude: String(dev.annotation.latitude), longitude: String(dev.annotation.longitude), validLatitude: true, validLongitude: true, easting: "", northing: "", zone: "", validEasting: true, validNorthing: true, validZone: true)
    }
}
