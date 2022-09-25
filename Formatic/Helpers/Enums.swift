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

enum WidgetsKey: CodingKey {
    case widgets
}

enum CheckboxWidgetsKey: CodingKey {
    case checkboxWidgets
}

enum WidgetTypeKey: CodingKey {
    case type
}

// Widget types
enum WidgetType: String, Decodable, Identifiable {
    
    var id: RawValue { rawValue }
    
    case textFieldWidget = "TextFieldWidget"
    case numberFieldWidget = "NumberFieldWidget"
    case textEditorWidget = "TextEditorWidget"
    case dropdownSectionWidget = "DropdownSectionWidget"
    case dropdownWidget = "DropdownWidget"
    case checkboxSectionWidget = "CheckboxSectionWidget"
    case checkboxWidget = "CheckboxWidget"
    case mapWidget = "MapWidget"
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
    case copyError
}

enum ImageError: Error {
    case dataToUIImageError
    case getImageFromContextError
    case mapSnapshotError
}
