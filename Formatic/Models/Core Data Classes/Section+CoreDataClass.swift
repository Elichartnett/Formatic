//
//  Section+CoreDataClass.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/28/22.
//
//

import Foundation
import CoreData

@objc(Section)
public class Section: NSManagedObject, Codable, Identifiable, Csv {
    
    func toCsv() -> String {
        var canvasWidgetCount = 0
        var retString = ""
        let allWidgets = (widgets ?? []).sorted { lhs, rhs in
            lhs.position < rhs.position
        }
        
        for item in allWidgets {
            let widgetType: WidgetType = WidgetType.init(rawValue: item.type!)!
            
            switch widgetType {
            case .dropdownSectionWidget:
                if let dropdownSectionWidget = item as? DropdownSectionWidget {
                    retString += dropdownSectionWidget.toCsv()
                }
            case .textFieldWidget:
                if let textFieldWidget = item as? TextFieldWidget {
                    retString += textFieldWidget.toCsv()
                }
            case .checkboxSectionWidget:
                if let checkboxSectionWidget = item as? CheckboxSectionWidget {
                    retString += checkboxSectionWidget.toCsv()
                }
            case .mapWidget:
                if let mapWidget = item as? MapWidget {
                    retString += mapWidget.toCsv()
                }
            case .numberFieldWidget:
                if let numberFieldWidget = item as? NumberFieldWidget {
                    retString += numberFieldWidget.toCsv()
                }
            case .textEditorWidget:
                if let textEditorWidget = item as? TextEditorWidget {
                    retString += textEditorWidget.toCsv()
                }
            case .dropdownWidget:
                break
            case .checkboxWidget:
                break
            case .canvasWidget:
                canvasWidgetCount += 1
            }
            retString += "\n"
        }
        // Remove trailing newline character IF widgets exist in section
        if retString != "" {
            retString.remove(at: retString.index(before: retString.endIndex))
        }
        if canvasWidgetCount > 0 {
            retString += "\nCount of canvas widgets in section,(Not Displayed),\(canvasWidgetCount)"
        }
        return retString
    }
    
    enum CodingKeys: String, CodingKey {
        case position = "position"
        case title = "title"
        case widgets = "widgets"
    }
    
    public func encode(to encoder: Encoder) throws {
        var sectionContainer = encoder.container(keyedBy: CodingKeys.self)
        try sectionContainer.encode(position, forKey: .position)
        try sectionContainer.encode(title, forKey: .title)
        try sectionContainer.encode(widgets, forKey: .widgets)
    }
    
    required public convenience init(from decoder: Decoder) throws {
        self.init(context: DataControllerModel.shared.container.viewContext)
        let sectionContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.position = try sectionContainer.decode(Int16.self, forKey: .position)
        if let title = try sectionContainer.decode(String?.self, forKey: .title) {
            self.title = title
        }
        
        // Decode widgets
        let widgetsContainer = try decoder.container(keyedBy: WidgetsKey.self) // Create base container that holds decodable section data
        var widgetsArrayForType = try widgetsContainer.nestedUnkeyedContainer(forKey: WidgetsKey.widgets) // Container that looks in base container (section) for "widgets" property
        var widgetsArray = widgetsArrayForType // Create copy - unkeyed container is used to decode a JSON array, and is decoded sequentially (each time you call a decode or nested container method on it, it advances to the next element in the array
        
        while(!widgetsArrayForType.isAtEnd) {
            let widget = try widgetsArrayForType.nestedContainer(keyedBy: WidgetTypeKey.self) // Get container for widget in widgetsArrayForType
            let type = try widget.decode(WidgetType.self, forKey: WidgetTypeKey.type) // Decode widget and get "type" property
            switch type {
            case .textFieldWidget:
                let textFieldWidget = try widgetsArray.decode(TextFieldWidget.self)
                textFieldWidget.section = self
                
            case .numberFieldWidget:
                let numberFieldWidget = try widgetsArray.decode(NumberFieldWidget.self)
                numberFieldWidget.section = self

            case .textEditorWidget:
                let textEditorWidget = try widgetsArray.decode(TextEditorWidget.self)
                textEditorWidget.section = self

            case .dropdownSectionWidget:
                let dropdownSectionWidget = try widgetsArray.decode(DropdownSectionWidget.self)
                dropdownSectionWidget.section = self
                
            // Will be handled in section
            case .dropdownWidget:
                break

            case .checkboxSectionWidget:
                let checkboxSectionWidget = try widgetsArray.decode(CheckboxSectionWidget.self)
                checkboxSectionWidget.section = self
                
            // Will be handled in section
            case .checkboxWidget:
                break

            case .mapWidget:
                let mapWidget = try widgetsArray.decode(MapWidget.self)
                mapWidget.section = self

            case .canvasWidget:
                let canvasWidget = try widgetsArray.decode(CanvasWidget.self)
                canvasWidget.section = self
            }
        }
    }
}
