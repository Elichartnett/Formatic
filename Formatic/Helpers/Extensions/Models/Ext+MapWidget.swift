//
//  Extensions+MapWidget.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/26/22.
//

import Foundation
import MapKit

extension MapWidget: Csv, Copyable {
    
    enum CodingKeys: CodingKey {
        case position
        case title
        case type
        case coordinateRegionCenterLat
        case coordinateRegionCenterLon
        case coordinateSpanLatDelta
        case coordinateSpanLonDelta
    }
    
    func updatePreviewSnapshot(size: CGSize) {
        let coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: self.coordinateRegionCenterLat, longitude: self.coordinateRegionCenterLon), span: MKCoordinateSpan(latitudeDelta: self.coordinateSpanLatDelta, longitudeDelta: self.coordinateSpanLonDelta))
        let options = MKMapSnapshotter.Options()
        options.region = coordinateRegion
        options.size = size
        
        let snapShotter = MKMapSnapshotter(options: options)
        snapShotter.start(with: DispatchQueue.global(qos: .userInitiated)) { snapshot, error in
            guard error == nil else {
                return
            }
            
            if let snapshotImage = snapshot?.image, let mapMarker = UIImage(systemName: Constants.mapPinIconName)?.withTintColor(.red) {
                UIGraphicsBeginImageContextWithOptions(options.size, true, snapshotImage.scale)
                snapshotImage.draw(at: CGPoint.zero)
                
                for annotation in self.annotations ?? [] {
                    if var point = snapshot?.point(for: CLLocationCoordinate2D(latitude: annotation.latitude, longitude: annotation.longitude)) {
                        point.x -= mapMarker.size.width / 2
                        point.y -= mapMarker.size.height / 2
                        mapMarker.draw(at: (point))
                    }
                }
                
                let mapImage = UIGraphicsGetImageFromCurrentImageContext()
                self.widgetViewPreview = mapImage?.jpegData(compressionQuality: 0.5) ?? Data()
                UIGraphicsEndImageContext()
            }
        }
    }
    
    func toCsv() -> String {
        var csvString = Constants.emptyString
        
        for annotation in annotations ?? [] {
            let coordinate = CLLocationCoordinate2D(latitude: annotation.latitude, longitude: annotation.longitude)
            let utm = coordinate.utmCoordinate()
            
            csvString += FormModel.formatAsCsv(section?.form?.title ?? Constants.emptyString) + ","
            csvString += FormModel.formatAsCsv(section?.title ?? Constants.emptyString) + ","
            csvString += FormModel.formatAsCsv(title ?? Constants.emptyString) + ","
            csvString += Strings.mapLabel + ","
            csvString += FormModel.formatAsCsv(annotation.name ?? Constants.emptyString) + ",,"
            csvString += String(annotation.latitude) + ","
            csvString += String(annotation.longitude) + ","
            csvString += String(utm.easting) + ","
            csvString += String(utm.northing) + ","
            csvString += String(utm.zone) + ","
            switch utm.hemisphere{
            case .southern: csvString += Strings.southernLabel
            case .northern: csvString += Strings.northernLabel
            }
            csvString += "\n"
        }
        
        if csvString != Constants.emptyString {
            csvString.remove(at: csvString.index(before: csvString.endIndex))
        }
        
        return csvString
    }
    
    func createCopy() -> Any {
        let copy = MapWidget(title: title, position: Int(position), coordinateRegionCenterLat: coordinateRegionCenterLat, coordinateRegionCenterLon: coordinateRegionCenterLon, coordinateSpanLatDelta: coordinateSpanLatDelta, coordinateSpanLonDelta: coordinateSpanLonDelta)
        
        _ = annotations?.sorted(by: { _,_ in true }).forEach({ annotation in
            let annotationCopy = Annotation(context: DataControllerModel.shared.container.viewContext)
            annotationCopy.id = UUID()
            annotationCopy.name = annotation.name
            annotationCopy.latitude = annotation.latitude
            annotationCopy.longitude = annotation.longitude
            annotationCopy.mapWidget = copy
            copy.annotations?.insert(annotationCopy)
        })
        
        return copy
    }
    
    func reset() {
        self.annotations = nil
    }
}
