//
//  Enums.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/28/22.
//

import Foundation

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

enum WidgetType: String, Decodable, Identifiable, CaseIterable {
    
    var id: RawValue { rawValue }
    
    case textFieldWidget = "TextFieldWidget"
    case numberFieldWidget = "NumberFieldWidget"
    case dateFieldWidget = "DateFieldWidget"
    case sliderWidget = "SliderWidget"
    case dropdownSectionWidget = "DropdownSectionWidget"
    case dropdownWidget = "DropdownWidget"
    case checkboxSectionWidget = "CheckboxSectionWidget"
    case checkboxWidget = "CheckboxWidget"
    case mapWidget = "MapWidget"
    case canvasWidget = "CanvasWidget"
}

enum CoordinateType: String, Identifiable, CaseIterable {
    
    var id: RawValue { rawValue}
    
    case latLon = "Latitude & Longitude"
    case utm = "Universal Transverse Mercator (UTM)"
    case center = "Center"
}

enum SourceType: String, Identifiable {
    var id: Self { self }
    
    case camera
    case photoLibrary
}

enum FormError: Error {
    case saveError
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

enum SortMethod: String {
    case dateCreated = "dateCreated"
    case alphabetical = "alphabetical"
}

enum WidgetViewHeight: CGFloat {
    case regular = 42
    case adaptive
    case large = 200
}

enum CustomColor: String {
    case primaryBackground = "primaryBackground"
    case secondaryBackground = "secondaryBackground"
    case customGray = "customGray"
}
