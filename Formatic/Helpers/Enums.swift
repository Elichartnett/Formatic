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
    case dropdownSectionWidget = "DropdownSectionWidget"
    case dropdownWidget = "DropdownWidget"
    case checkboxSectionWidget = "CheckboxSectionWidget"
    case checkboxWidget = "CheckboxWidget"
    case mapWidget = "MapWidget"
    case photoLibraryWidget = "PhotoLibraryWidget"
    case photoWidget = "PhotoWidget"
    case canvasWidget = "CanvasWidget"
}

// Coordinate types
enum CoordinateType: String, Identifiable, CaseIterable {
    
    var id: RawValue { rawValue}
    
    case latLon = "Latitude & Longitude"
    case utm = "Universal Transverse Mercator (UTM)"
    case center = "Center"
}

// Image types
enum SourceType: String, Identifiable {
    var id: Self { self }
    
    case camera
    case photoLibrary
}

enum FormError: Error {
    case fetchError
    case encodeFormToJsonDataError
    case urlToDataError
    case decodeJsonDataToFormError
}
