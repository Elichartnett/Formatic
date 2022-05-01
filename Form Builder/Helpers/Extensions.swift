//
//  Extensions.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/29/22.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    
    let form: Form
    let section: Section

    private init() {
        
        // Create form
        form = Form(title: "Form title")
        
        // Add section
        section = Section(title: "Section title")
        form.addToSections(section)
        
        // Create TextFieldWidget
        let textFieldWidget = TextFieldWidget(title: "Text field title", text: "Text field text")
        
        // Create NumberFieldWidget
        let numberFieldWidget = NumberFieldWidget(title: "Number field title", number: "0.00")
        
        // Create TextEditorWidget
        let textEditorWidget = TextEditorWidget(title: "Text editor title", text: "Text editor text")
        
        // Create DropdownSectionWidget section
        let dropdownSection = DropdownSectionWidget(title: "Dropdown section title")
        let dropdownWidget = DropdownWidget(title: "Dropdown option 1")
        dropdownSection.addToDropdowns(dropdownWidget)
        
        // Create CheckboxSectionWidget
        let checkboxSection = CheckboxSectionWidget(title: "Checkbox section title")
        let checkboxWidget = CheckboxWidget(title: "Checkbox option 1")
        checkboxSection.addToCheckboxes(checkboxWidget)
        
        // Create MapWidget
        let mapWidget = MapWidget(title: "Map title")
        
        // Create PhotoLibraryWidget
        let photoLibraryWidget = PhotoLibraryWidget(title: "Photo library widget title")
        
        // Create CanvasWidget
        let canvasWidget = CanvasWidget(title: "Canvas widget title")
        
        // Add all widgets to section
        section.addToWidgets(NSSet(array: [textFieldWidget, numberFieldWidget, textEditorWidget, dropdownSection, checkboxSection, mapWidget, photoLibraryWidget, canvasWidget]))
    }
}
