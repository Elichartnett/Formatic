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
public class Section: NSManagedObject {
    
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
                
            case .dateFieldWidget:
                let dateFieldWidget = try widgetsArray.decode(DateFieldWidget.self)
                dateFieldWidget.section = self
                
            case .sliderWidget:
                let sliderWidget = try widgetsArray.decode(SliderWidget.self)
                sliderWidget.section = self

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
