//
//  DeveloperPreview.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/13/22.
//

import Foundation
import MapKit

class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    
    let form: Form
    let section: Section
    let newWidgetType: WidgetType
    let textFieldWidget: TextFieldWidget
    let numberFieldWidget: NumberFieldWidget
    let textEditorWidget: TextEditorWidget
    let dropdownWidget: DropdownWidget
    let dropdownSectionWidget: DropdownSectionWidget
    let checkboxWidget: CheckboxWidget
    let checkboxSectionWidget: CheckboxSectionWidget
    let mapWidget: MapWidget
    let annotation: Annotation
    let coordinateRegion: MKCoordinateRegion
    let photoLibraryWidget: PhotoLibraryWidget
    let photoWidget: PhotoWidget
    let canvasWidget: CanvasWidget
    
    private init() {
        
        // Create form
        form = Form(position: Int16(1), title: "Form title")
        
        // Add section
        section = Section(position: 0, title: "Section title")
        form.addToSections(section)
        
        newWidgetType = .textFieldWidget
        
        // Create TextFieldWidget
        textFieldWidget = TextFieldWidget(title: "Text field title", position: 1, text: "Text field text")
        
        // Create NumberFieldWidget
        numberFieldWidget = NumberFieldWidget(title: "Number field title", position: 2, number: "0.00")
        
        // Create TextEditorWidget
        textEditorWidget = TextEditorWidget(title: "Text editor title", position: 3, text: "Text editor text")
        
        // Create DropdownSectionWidget section
        dropdownSectionWidget = DropdownSectionWidget(title: "Dropdown section title", position: 4)
        dropdownWidget = DropdownWidget(title: "Dropdown option 1", position: 0)
        dropdownSectionWidget.selectedDropdown = dropdownWidget
        dropdownSectionWidget.addToDropdownWidgets(dropdownWidget)
        
        // Create CheckboxSectionWidget
        checkboxSectionWidget = CheckboxSectionWidget(title: "Checkbox section title", position: 5)
        checkboxWidget = CheckboxWidget(title: "Checkbox 1", position: 0)
        checkboxSectionWidget.addToCheckboxWidgets(checkboxWidget)
        
        // Create MapWidget
        mapWidget = MapWidget(title: "Map title", position: 6)
        annotation = Annotation(context: DataController.shared.container.viewContext)
        annotation.latitude = 0.0
        annotation.longitude = 0.0
        mapWidget.addToAnnotations(annotation)
        coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.0902, longitude: -95.7129), span: MKCoordinateSpan(latitudeDelta: 70, longitudeDelta: 70))
        
        // Create PhotoLibraryWidget
        photoLibraryWidget = PhotoLibraryWidget(title: "Photo library widget title", position: 7)
        photoWidget = PhotoWidget(title: "Photo title", position: 0, photo: UIImage().jpegData(compressionQuality: 0.1))
        photoLibraryWidget.addToPhotoWidgets(photoWidget)
        
        // Create CanvasWidget
        canvasWidget = CanvasWidget(title: "Canvas widget title", position: 8)
        
        // Add all widgets to section
        section.addToWidgets(NSSet(array: [textFieldWidget, numberFieldWidget, textEditorWidget, dropdownSectionWidget, checkboxSectionWidget, mapWidget, photoLibraryWidget, canvasWidget]))
    }
}
