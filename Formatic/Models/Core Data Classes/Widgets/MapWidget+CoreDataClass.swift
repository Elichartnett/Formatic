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
public class MapWidget: Widget, Decodable, Csv {
    
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
                csvString += FormModel.formatAsCsv(self.section?.title ?? "") + ","
                csvString += FormModel.formatAsCsv(self.title ?? "") + ","
                csvString += (self.type ?? "") + ","
                csvString += FormModel.formatAsCsv(annotation.name ?? "") + ",,"
                csvString += String(annotation.latitude) + ","
                csvString += String(annotation.longitude) + ","
                csvString += String(utm.easting) + ","
                csvString += String(utm.northing) + ","
                csvString += String(utm.zone) + ","
                switch utm.hemisphere{
                case .southern: csvString += "Southern"
                case .northern: csvString += "Northern"
                }
                csvString += "\n"
            }
        }
        
        // Remove traling newline character (if retString exists/annotations exist in the map)
        if csvString != "" {
            csvString.remove(at: csvString.index(before: csvString.endIndex))
        }
        
        return csvString
    }
}
