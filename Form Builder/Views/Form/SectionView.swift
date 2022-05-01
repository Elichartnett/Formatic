//
//  SectionView.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/29/22.
//

import SwiftUI

// Displays form sections with section titles and widgets
struct SectionView: View {
    
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var section: Section
    
    var body: some View {
        
        VStack {
            
            Text(section.title ?? "")
            
            // Display all widgets in section
            List() {
                ForEach(section.widgetsArray) { widget in
                    let widgetType: WidgetType = WidgetType.init(rawValue: widget.type ?? "") ?? .unknown
                    
                    switch widgetType {
                    case .textFieldWidget:
                        let textFieldWidget = widget as! TextFieldWidget
                        Text(textFieldWidget.title ?? "")
                        
                    case .numberFieldWidget:
                        let numberFieldWidget = widget as! NumberFieldWidget
                        Text(numberFieldWidget.title ?? "")
                        
                    case .textEditorWidget:
                        let textEditorWidget = widget as! TextEditorWidget
                        Text(textEditorWidget.title ?? "")
                        
                    case .dropdownSectionWidget:
                        let dropdownSectionWidget = widget as! DropdownSectionWidget
                        Text(dropdownSectionWidget.title ?? "")
                        
                    case .checkboxSectionWidget:
                        let checkboxSectionWidget = widget as! CheckboxSectionWidget
                        Text(checkboxSectionWidget.title ?? "")
                        
                    case .mapWidget:
                        let mapWidget = widget as! MapWidget
                        Text(mapWidget.title ?? "")
                        
                    case .photoLibraryWidget:
                        let photoLibraryWidget = widget as! PhotoLibraryWidget
                        Text(photoLibraryWidget.title ?? "")
                        
                    case .canvasWidget:
                        let canvasWidget = widget as! CanvasWidget
                        Text(canvasWidget.title ?? "")
                        
                    case .unknown:
                        Text("unknown")
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let widget = section.widgetsArray[index]
                        moc.delete(widget)
                        DataController.saveMOC()
                    }
                }
            }
        }
    }
}

struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionView(section: dev.form.sectionsArray.first!)
    }
}
