//
//  AddAnnotationsView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/11/22.
//

import SwiftUI
import UTMConversion
import MapKit

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
    
    var body: some View {
        
        VStack {
            
            Picker(Strings.coordinateTypePickerLabel, selection: $coordinateType) {
                ForEach(CoordinateType.allCases) { type in
                    Text(type.rawValue)
                        .tag(type)
                }
            }
            .pickerStyle(.segmented)
            
            HStack {
                if coordinateType == .latLon {
                    if formModel.isPhone {
                        VStack {
                            BaseLatLonView(latitude: $latitude, validLatitude: $validLatitude, longitude: $longitude, validLongitude: $validLongitude, coordinateType: coordinateType)
                        }
                    }
                    else {
                        HStack {
                            BaseLatLonView(latitude: $latitude, validLatitude: $validLatitude, longitude: $longitude, validLongitude: $validLongitude, coordinateType: coordinateType)
                        }
                    }
                }
                else if coordinateType == .utm {
                    if formModel.isPhone {
                        BaseUTMView(isPhone: true,easting: $easting, validEasting: $validEasting, northing: $northing, validNorthing: $validNorthing, zone: $zone, validZone: $validZone, hemisphere: $hemisphere)
                    }
                    else {
                        BaseUTMView(isPhone: false,easting: $easting, validEasting: $validEasting, northing: $northing, validNorthing: $validNorthing, zone: $zone, validZone: $validZone, hemisphere: $hemisphere)
                    }
                }
                else if coordinateType == .center {
                    if formModel.isPhone {
                        BaseCenterView(isPhone: true, localCoordinateRegion: localCoordinateRegion)
                    }
                    else {
                        BaseCenterView(isPhone: false, localCoordinateRegion: localCoordinateRegion)
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
                    VStack {
                        Image(systemName: Constants.plusIconName)
                        Text(Strings.addPinLabel)
                    }
                }
                .disabled(coordinateType == .latLon ? !(validLatitude && validLongitude) : coordinateType == .utm ? !(validEasting && validNorthing && validZone) : false)
            }
            .animation(.default, value: coordinateType)
            .padding(.vertical, 10)
        }
    }
}

struct AddAnnotationsView_Previews: PreviewProvider {
    static var previews: some View {
        AddAnnotationsView(mapWidget: dev.mapWidget, localCoordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: dev.mapWidget.coordinateRegionCenterLat, longitude: dev.mapWidget.coordinateRegionCenterLon), span: MKCoordinateSpan(latitudeDelta: dev.mapWidget.coordinateSpanLatDelta, longitudeDelta: dev.mapWidget.coordinateSpanLonDelta))), coordinateType: .constant(.latLon), latitude: String(dev.annotation.latitude), longitude: String(dev.annotation.longitude), validLatitude: true, validLongitude: true, easting: "", northing: "", zone: "", validEasting: true, validNorthing: true, validZone: true)
            .environmentObject(FormModel())
    }
}

struct BaseLatLonView: View {
    
    @Binding var latitude: String
    @Binding var validLatitude: Bool
    @Binding var longitude: String
    @Binding var validLongitude: Bool
    let coordinateType: CoordinateType
    
    var body: some View {
        
        InputBox(placeholder: Strings.latitudeLabel, text: $latitude, inputType: .number, isValid: $validLatitude, validRange: -90...90)
            .titleFrameStyle(locked: .constant(false))
        InputBox(placeholder: Strings.longitudeLabel, text: $longitude, inputType: .number, isValid: $validLongitude, validRange: -180...180)
            .titleFrameStyle(locked: .constant(false))
    }
}

struct BaseUTMView: View {
    
    let isPhone: Bool
    @Binding var easting: String
    @Binding var validEasting: Bool
    @Binding var northing: String
    @Binding var validNorthing: Bool
    @Binding var zone: String
    @Binding var validZone: Bool
    @Binding var hemisphere: UTMHemisphere
    
    var body: some View {
        
        let eastingView = InputBox(placeholder: Strings.eastingLabel, text: $easting, inputType: .number, isValid: $validEasting, validRange: 166640...833360)
            .titleFrameStyle(locked: .constant(false))
        let northingView = InputBox(placeholder: Strings.northingLabel, text: $northing, inputType: .number, isValid: $validNorthing, validRange: 1110400...9334080)
            .titleFrameStyle(locked: .constant(false))
        
        let zoneView = InputBox(placeholder: Strings.zoneLabel, text: $zone, inputType: .number, isValid: $validZone, validRange: 1...60)
        
        let pickerView = Picker(Strings.hemisphereLabel, selection: $hemisphere) {
            Text(Strings.northernLabel)
                .tag(UTMHemisphere.northern)
            Text(Strings.southernLabel)
                .tag(UTMHemisphere.southern)
        }
            .pickerStyle(.menu)
        
        if isPhone {
            HStack(alignment: .top) {
                VStack {
                    eastingView
                    northingView
                }
                VStack {
                    zoneView
                    pickerView
                }
            }
        }
        else {
            HStack(alignment: .top) {
                eastingView
                northingView
                zoneView
                pickerView
            }
        }
    }
}

struct BaseCenterView: View {
    
    let isPhone: Bool
    let localCoordinateRegion: MKCoordinateRegion
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    var body: some View {
        
        let latitudeLabel = VStack {
            Text(Strings.latitudeLabel).bold().underline()
            Text(formatter.string(from: localCoordinateRegion.center.latitude as NSNumber)!)
        }
        let longitudeLabel = VStack {
            Text(Strings.longitudeLabel).bold().underline()
            Text(formatter.string(from: localCoordinateRegion.center.longitude as NSNumber)!)
        }
        let eastingLabel = VStack {
            Text(Strings.eastingLabel).bold().underline()
            Text(formatter.string(from: localCoordinateRegion.center.utmCoordinate().easting as NSNumber)!)
        }
        let northingLabel = VStack {
            Text(Strings.northingLabel).bold().underline()
            Text(formatter.string(from: localCoordinateRegion.center.utmCoordinate().northing as NSNumber)!)
        }
        let zoneLabel = VStack {
            Text(Strings.zoneLabel).bold().underline()
            Text(formatter.string(from: localCoordinateRegion.center.utmCoordinate().zone as NSNumber)!)
        }
        let hemisphereLabel = VStack {
            Text(Strings.hemisphereLabel).bold().underline()
            Text(localCoordinateRegion.center.utmCoordinate().hemisphere == .northern ? Strings.northernLabel : Strings.southernLabel)
        }
        
        if isPhone {
            VStack {
                latitudeLabel
                longitudeLabel
            }
            VStack {
                eastingLabel
                northingLabel
            }
            VStack {
                zoneLabel
                hemisphereLabel
            }
        }
        else {
            HStack {
                latitudeLabel
                longitudeLabel
                eastingLabel
                northingLabel
                zoneLabel
                hemisphereLabel
            }
        }
    }
}
