//
//  Enums.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/28/22.
//

import Foundation

// InputBox input types
enum InputType {
    case text
    case number
    case password
}

// Widget types
enum WidgetType: String, Identifiable {
    
    var id: RawValue { rawValue }
    
    case textFieldWidget = "TextFieldWidget"
    case numberFieldWidget = "NumberFieldWidget"
    case textEditorWidget = "TextEditorWidget"
    case dropdownWidget = "DropdownWidget"
    case dropdownSectionWidget = "DropdownSectionWidget"
    case checkboxWidget = "CheckboxWidget"
    case checkboxSectionWidget = "CheckboxSectionWidget"
    case mapWidget = "MapWidget"
    case photoLibraryWidget = "PhotoLibraryWidget"
    case canvasWidget = "CanvasWidget"
}

// Coordinate types
enum CoordinateType: String, Identifiable, CaseIterable {
    
    var id: RawValue { rawValue}
    
    case latLon = "Latitude & Longitude"
    case utm = "Universal Transverse Mercator (UTM)"
    case center = "Center"
}
