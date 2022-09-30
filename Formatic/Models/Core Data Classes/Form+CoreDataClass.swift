//
//  Form+CoreDataClass.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/30/22.
//
//

import Foundation
import CoreData

@objc(Form)
public class Form: NSManagedObject, Codable, Identifiable, Csv, Copyable {
    
    enum CodingKeys: String, CodingKey {
        case locked = "locked"
        case title = "title"
        case sections = "sections"
    }
    
    public func encode(to encoder: Encoder) throws {
        var formContainer = encoder.container(keyedBy: CodingKeys.self)
        
        try formContainer.encode(locked, forKey: .locked)
        try formContainer.encode(title, forKey: .title)
        try formContainer.encode(sections, forKey: .sections)
    }
    
    required public convenience init(from decoder: Decoder) throws {
        self.init(context: DataControllerModel.shared.container.viewContext)
        
        let formContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.locked = try formContainer.decode(Bool.self, forKey: .locked)
        if let title = try formContainer.decode(String?.self, forKey: .title) {
            self.title = title
        }
        if let sections = try formContainer.decode(Set<Section>?.self, forKey: .sections) {
            self.sections = sections
        }
    }
    
    func toCsv() -> String {
        var csvString = ""
        csvString += "Section Title, Widget Title, Widget Type, Widget Data, Selected, Marker Latitude, Marker Longitude, Marker Easting, Marker Northing, Marker Zone, Marker Hemisphere\n"
        
        let sections = (sections ?? []).sorted { lhs, rhs in
            lhs.position < rhs.position
        }
                
        for section in sections {
            csvString += section.toCsv()
            csvString += "\n\n"
        }
        // Remove trailing newline characters
        csvString.remove(at: csvString.index(before: csvString.endIndex))
        csvString.remove(at: csvString.index(before: csvString.endIndex))
        return csvString
    }
    
    func createCopy() -> Any {
        let copy = Form(position: Int(self.position), title: self.title!)
        copy.locked = locked
        copy.password = password
        
        let sectionsArray = sections?.sorted(by: { lhs, rhs in
            lhs.position < rhs.position
        }) ?? []
        for section in sectionsArray {
            let sectionCopy = section.createCopy() as! Section
            copy.addToSections(sectionCopy)
        }
        return copy
    }
}
