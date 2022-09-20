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
public class MapWidget: Widget, Decodable, CSV {
    
    func ToCsv() -> String {
        let annotations = self.annotations?.allObjects
        var retString = ""
        
        for item in annotations ?? [] {
            if let anno = item as? Annotation {
                // Get the UTM version of the coordinate as well
                let coordinate = CLLocationCoordinate2D(latitude: anno.latitude, longitude: anno.longitude)
                let utm = coordinate.utmCoordinate()
                retString += FormModel.csvFormat(self.section?.title ?? "") + ","
                retString += FormModel.csvFormat(self.title ?? "") + ","
                retString += (self.type ?? "") + ","
                retString += FormModel.csvFormat(anno.name ?? "") + ",,"
                retString += String(anno.latitude) + ","
                retString += String(anno.longitude) + ","
                retString += String(utm.easting) + ","
                retString += String(utm.northing) + ","
                retString += String(utm.zone) + ","
                switch utm.hemisphere{
                case .southern: retString += "Southern"
                case .northern: retString += "Northern"
                }
                retString += "\n"
            }
        }
        // Remove traling newline character (if retString exists/annotations exist in the map)
        if retString != "" {
            retString.remove(at: retString.index(before: retString.endIndex))
        }
        return retString
    }
    
    /// MapWidget  init
    init(title: String?, position: Int, coordinateRegionCenterLat: Double, coordinateRegionCenterLon: Double, coordinateSpanLatDelta: Double, coordinateSpanLonDelta: Double) {
        super.init(entityName: "MapWidget", context: DataController.shared.container.viewContext, title: title, position: position)
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
        super.init(entityName: "MapWidget", context: DataController.shared.container.viewContext, title: nil, position: 0)

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
}
