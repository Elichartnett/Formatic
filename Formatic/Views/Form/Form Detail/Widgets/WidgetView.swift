//
//  WidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/27/22.
//

import SwiftUI

struct WidgetView: View {
    
    @ObservedObject var widget: Widget
    @Binding var locked: Bool
    var forPDF: Bool = false
    
    var body: some View {
        
        if widget.type != nil, let widgetType: WidgetType = WidgetType.init(rawValue: widget.type!) {
            HStack {
                Group {
                    switch widgetType {
                    case .textFieldWidget:
                        if let textFieldWidget = widget as? TextFieldWidget {
                            TextFieldWidgetView(textFieldWidget: textFieldWidget, locked: $locked)
                        }
                        
                    case .numberFieldWidget:
                        let numberFieldWidget = widget as! NumberFieldWidget
                        NumberFieldWidgetView(numberFieldWidget: numberFieldWidget, locked: $locked)
                        
                    case .dropdownSectionWidget:
                        let dropdownSectionWidget = widget as! DropdownSectionWidget
                        DropdownSectionWidgetView(dropdownSectionWidget: dropdownSectionWidget, locked: $locked)
                        
                        // Will be handled in section
                    case .dropdownWidget:
                        EmptyView()
                        
                    case .checkboxSectionWidget:
                        let checkboxSectionWidget = widget as! CheckboxSectionWidget
                        CheckboxSectionWidgetView(checkboxSectionWidget: checkboxSectionWidget, locked: $locked)
                        
                        // Will be handled in section
                    case .checkboxWidget:
                        EmptyView()
                        
                    case .mapWidget:
                        let mapWidget = widget as! MapWidget
                        MapWidgetView(mapWidget: mapWidget, locked: $locked, forPDF: forPDF)
                        
                    case .canvasWidget:
                        let canvasWidget = widget as! CanvasWidget
                        CanvasWidgetView(canvasWidget: canvasWidget, locked: $locked)
                    }
                }
                .swipeActions {
                    if !locked {
                        Button {
                            widget.delete()
                        } label: {
                            Labels.delete
                        }
                        .tint(.red)
                        
                        Button {
                            widget.initiateCopy()
                        } label: {
                            Labels.copy
                        }
                        .tint(.blue)
                    }
                }
            }

        }
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView(widget: dev.textFieldWidget, locked: .constant(false))
    }
}
