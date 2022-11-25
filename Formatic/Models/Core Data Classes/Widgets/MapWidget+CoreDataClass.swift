//
//  MapWidget+CoreDataClass.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/29/22.
//
//

import Foundation
import CoreData
import UTMConversion
import MapKit

@objc(MapWidget)
public class MapWidget: Widget, Decodable, Csv, Copyable {
    
    /// MapWidget  init
    init(title: String?, position: Int, coordinateRegionCenterLat: Double, coordinateRegionCenterLon: Double, coordinateSpanLatDelta: Double, coordinateSpanLonDelta: Double) {
        super.init(entityName: "MapWidget", context: DataControllerModel.shared.container.viewContext, title: title, position: position)
        self.type = WidgetType.mapWidget.rawValue
        self.coordinateRegionCenterLat = coordinateRegionCenterLat
        self.coordinateRegionCenterLon = coordinateRegionCenterLon
        self.coordinateSpanLatDelta = coordinateSpanLatDelta
        self.coordinateSpanLonDelta = coordinateSpanLonDelta
    }
    
    enum CodingKeys: String, CodingKey {
        case position = "position"
        case title = "title"
        case type = "type"
        case coordinateRegionCenterLat = "coordinateRegionCenterLat"
        case coordinateRegionCenterLon = "coordinateRegionCenterLon"
        case coordinateSpanLatDelta = "coordinateSpanLatDelta"
        case coordinateSpanLonDelta = "coordinateSpanLonDelta"
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        
        var mapWidgetContainer = encoder.container(keyedBy: CodingKeys.self)
        try mapWidgetContainer.encode(coordinateRegionCenterLat, forKey: .coordinateRegionCenterLat)
        try mapWidgetContainer.encode(coordinateRegionCenterLon, forKey: .coordinateRegionCenterLon)
        try mapWidgetContainer.encode(coordinateSpanLatDelta, forKey: .coordinateSpanLatDelta)
        try mapWidgetContainer.encode(coordinateSpanLonDelta, forKey: .coordinateSpanLonDelta)
    }
    
    required public init(from decoder: Decoder) throws {
        super.init(entityName: "MapWidget", context: DataControllerModel.shared.container.viewContext, title: nil, position: 0)
        
        let mapWidgetContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.position = try mapWidgetContainer.decode(Int16.self, forKey: .position)
        if let title = try mapWidgetContainer.decode(String?.self, forKey: .title) {
            self.title = title
        }
        self.type = try mapWidgetContainer.decode(String.self, forKey: .type)
        
        self.coordinateRegionCenterLat = try mapWidgetContainer.decode(Double.self, forKey: .coordinateRegionCenterLat)
        self.coordinateRegionCenterLon = try mapWidgetContainer.decode(Double.self, forKey: .coordinateRegionCenterLon)
        self.coordinateSpanLatDelta = try mapWidgetContainer.decode(Double.self, forKey: .coordinateSpanLatDelta)
        self.coordinateSpanLonDelta = try mapWidgetContainer.decode(Double.self, forKey: .coordinateSpanLonDelta)
    }
    
    func toCsv() -> String {
        let annotations = self.annotations?.allObjects
        var csvString = ""
        
        for item in annotations ?? [] {
            if let annotation = item as? Annotation {
                // Get the UTM version of the coordinate as well
                let coordinate = CLLocationCoordinate2D(latitude: annotation.latitude, longitude: annotation.longitude)
                let utm = coordinate.utmCoordinate()
                
                csvString += FormModel.formatAsCsv(section?.form?.title ?? "") + ","
                csvString += FormModel.formatAsCsv(section?.title ?? "") + ","
                csvString += FormModel.formatAsCsv(title ?? "") + ","
                csvString += Strings.mapLabel + ","
                csvString += FormModel.formatAsCsv(annotation.name ?? "") + ",,"
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
        }
        
        // Remove traling newline character
        if csvString != "" {
            csvString.remove(at: csvString.index(before: csvString.endIndex))
        }
        
        return csvString
    }
    
    func createCopy() -> Any {
        let copy = MapWidget(title: title, position: Int(position), coordinateRegionCenterLat: coordinateRegionCenterLat, coordinateRegionCenterLon: coordinateRegionCenterLon, coordinateSpanLatDelta: coordinateSpanLatDelta, coordinateSpanLonDelta: coordinateSpanLonDelta)
        copy.annotations = annotations
        return copy
    }
}
