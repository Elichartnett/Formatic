//
//  Extension+Widget.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/26/22.
//

import Foundation

extension Widget: Identifiable {
    
    enum CodingKeys: CodingKey {
        case position
        case title
        case type
    }
    
    func delete() {
        let widgets = self.section?.sortedWidgetsArray() ?? []
        
        for index in Int(self.position)..<widgets.count {
            widgets[index].position = widgets[index].position - 1
        }
        DataControllerModel.shared.container.viewContext.delete(self)
    }
    
    func initiateCopy() {
        let widgets = self.section?.sortedWidgetsArray() ?? []

        for index in Int(self.position + 1)..<widgets.count {
            widgets[index].position = widgets[index].position + 1
        }
        
        let widgetType = WidgetType(rawValue: self.type!)!
        
        switch widgetType {
        case .textFieldWidget:
            if let widget = self as? TextFieldWidget {
                let copy = widget.createCopy() as! TextFieldWidget
                copy.position = widget.position + 1
                section?.addToWidgets(copy)
            }
        case .numberFieldWidget:
            if let widget = self as? NumberFieldWidget {
                let copy = widget.createCopy() as! NumberFieldWidget
                copy.position = widget.position + 1
                section?.addToWidgets(copy)
            }
        case .dateFieldWidget:
            if let widget = self as? DateFieldWidget {
                let copy = widget.createCopy() as! DateFieldWidget
                copy.position = widget.position + 1
                section?.addToWidgets(copy)
            }
        case .sliderWidget:
            if let widget = self as? SliderWidget {
                let copy = widget.createCopy() as! SliderWidget
                copy.position = widget.position + 1
                section?.addToWidgets(copy)
            }
        case .dropdownSectionWidget:
            if let widget = self as? DropdownSectionWidget {
                let copy = widget.createCopy() as! DropdownSectionWidget
                copy.position = widget.position + 1
                section?.addToWidgets(copy)
            }
        case .dropdownWidget:
            break
        case .checkboxSectionWidget:
            if let widget = self as? CheckboxSectionWidget {
                let copy = widget.createCopy() as! CheckboxSectionWidget
                copy.position = widget.position + 1
                section?.addToWidgets(copy)
            }
        case .checkboxWidget:
            break
        case .mapWidget:
            if let widget = self as? MapWidget {
                let copy = widget.createCopy() as! MapWidget
                copy.position = widget.position + 1
                section?.addToWidgets(copy)
            }
        case .canvasWidget:
            if let widget = self as? CanvasWidget {
                let copy = widget.createCopy() as! CanvasWidget
                copy.position = widget.position + 1
                section?.addToWidgets(copy)
            }
        }
    }
}
