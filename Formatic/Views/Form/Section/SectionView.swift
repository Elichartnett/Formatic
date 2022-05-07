//
//  SectionView.swift
// Formatic
//
//  Created by Eli Hartnett on 4/29/22.
//

import SwiftUI

// Displays form sections with section titles and widgets
struct SectionView: View {
    
    @Environment(\.managedObjectContext) var moc    
    @ObservedObject var section: Section
    @Binding var locked: Bool
    
    var body: some View {
        
        // Display all widgets in section
        ForEach(section.widgetsArray) { widget in
            let widgetType: WidgetType = WidgetType.init(rawValue: widget.type!)!
            
            switch widgetType {
            case .textFieldWidget:
                let textFieldWidget = widget as! TextFieldWidget
                TextFieldWidgetView(textFieldWidget: textFieldWidget, locked: $locked)
                
            case .numberFieldWidget:
                let numberFieldWidget = widget as! NumberFieldWidget
                NumberFieldWidgetView(numberFieldWidget: numberFieldWidget, locked: $locked)
                
            case .textEditorWidget:
                let textEditorWidget = widget as! TextEditorWidget
                TextEditorWidgetView(textEditorWidget: textEditorWidget, locked: $locked)
                
            case .dropdownWidget:
                EmptyView()
                
            case .dropdownSectionWidget:
                let dropdownSectionWidget = widget as! DropdownSectionWidget
                DropdownSectionWidgetView(dropdownWidgetSection: dropdownSectionWidget)
                
            case .checkboxWidget:
                EmptyView()
                
            case .checkboxSectionWidget:
                let checkboxSectionWidget = widget as! CheckboxSectionWidget
                CheckboxSectionWidgetView(checkboxSectionWidget: checkboxSectionWidget)
                
            case .mapWidget:
                let mapWidget = widget as! MapWidget
                MapWidgetView(mapWidget: mapWidget)
                
            case .photoLibraryWidget:
                let photoLibraryWidget = widget as! PhotoLibraryWidget
                PhotoLibraryWidgetView(photoLibraryWidget: photoLibraryWidget)
                
            case .canvasWidget:
                let canvasWidget = widget as! CanvasWidget
                CanvasWidgetView(canvasWidget: canvasWidget)
            }
        }
        .onMove(perform: { indexSet, destination in
            // Temporary array with new indexes
            var movedArray = section.widgetsArray
            movedArray.move(fromOffsets: indexSet, toOffset: destination)
            
            // Store new positions in core data
            for (index, widget) in movedArray.enumerated() {
                let coreDataWidget = section.widgetsArray.first { coreDataWidget in
                    coreDataWidget.id == widget.id
                }
                coreDataWidget?.position = Int16(index)
            }
            section.objectWillChange.send()
            DataController.saveMOC()
        })
        .onDelete { indexSet in
            for index in indexSet {
                let widget = section.widgetsArray[index]
                moc.delete(widget)
                DataController.saveMOC()
            }
        }
    }
}

struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionView(section: dev.form.sectionsArray.first!, locked: .constant(dev.form.locked))
            .environmentObject(FormModel())
    }
}
