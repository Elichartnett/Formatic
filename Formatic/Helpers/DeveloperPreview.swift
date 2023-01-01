//
//  DeveloperPreview.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/13/22.
//

import Foundation
import SwiftUI
import MapKit

class DeveloperPreview {
    
    static let shared = DeveloperPreview()
    
    let formModel: FormModel = FormModel()
    let form: Form
    let section: Section
    let newWidgetType: WidgetType
    let textFieldWidget: TextFieldWidget
    let numberFieldWidget: NumberFieldWidget
    let dateFieldWidget: DateFieldWidget
    let sliderWidget: SliderWidget
    let dropdownWidget: DropdownWidget
    let dropdownSectionWidget: DropdownSectionWidget
    let checkboxWidget: CheckboxWidget
    let checkboxSectionWidget: CheckboxSectionWidget
    let mapWidget: MapWidget
    let annotation: Annotation
    let coordinateRegion: MKCoordinateRegion
    let canvasWidget: CanvasWidget
    
    private init() {
        
        form = Form(title: "Form title")
        
        section = Section(position: 0, title: "Section title")
        form.addToSections(section)
        
        newWidgetType = .textFieldWidget
        
        textFieldWidget = TextFieldWidget(title: "Text field title", position: 1, text: "Text field text")
        
        numberFieldWidget = NumberFieldWidget(title: "Number field title", position: 2, number: "0.00")
        
        dateFieldWidget = DateFieldWidget(title: "Date field title", position: 3, date: Date())
        
        sliderWidget = SliderWidget(title: "Slider widget title", position: 4, lowerBound: "1", upperBound: "5", step: "1", number: "1")
        
        dropdownSectionWidget = DropdownSectionWidget(title: "Dropdown section title", position: 5, selectedDropdown: nil, dropdownWidgets: nil)
        dropdownWidget = DropdownWidget(title: "Dropdown option 1", position: 0, dropdownSectionWidget: nil, selectedDropdownInverse: nil)
        dropdownSectionWidget.selectedDropdown = dropdownWidget
        dropdownSectionWidget.addToDropdownWidgets(dropdownWidget)
        
        checkboxSectionWidget = CheckboxSectionWidget(title: "Checkbox section title", position: 6, checkboxWidgets: nil)
        checkboxWidget = CheckboxWidget(title: "Checkbox 1", position: 0, checked: true, checkboxSectionWidget: checkboxSectionWidget)
        checkboxSectionWidget.addToCheckboxWidgets(checkboxWidget)
        
        mapWidget = MapWidget(title: "Map title", position: 7, coordinateRegionCenterLat: 37.0902, coordinateRegionCenterLon: -95.7129, coordinateSpanLatDelta: 70, coordinateSpanLonDelta: 70)
        annotation = Annotation(context: DataControllerModel.shared.container.viewContext)
        annotation.latitude = 0.0
        annotation.longitude = 0.0
        mapWidget.addToAnnotations(annotation)
        coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.0902, longitude: -95.7129), span: MKCoordinateSpan(latitudeDelta: 90, longitudeDelta: 90))
        
        canvasWidget = CanvasWidget(title: "Canvas widget title", position: 8, image: nil, pkDrawing: nil, widgetViewPreview: nil)
        canvasWidget.widgetViewPreview = UIImage(systemName: "photo")?.pngData()
        
        section.addToWidgets(NSSet(array: [textFieldWidget, numberFieldWidget, dateFieldWidget, sliderWidget, dropdownSectionWidget, checkboxSectionWidget, mapWidget, canvasWidget]))
    }
}
