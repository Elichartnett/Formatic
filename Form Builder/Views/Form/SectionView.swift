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
    
    @State var newWidgetType: WidgetType?
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Text(section.title ?? "")
                
                Menu {
                    // Add TextFieldWidget to section
                    Button("Text Field") {
                        newWidgetType = .textFieldWidget
                    }
                    
                    // Add NumberFieldWidget to section
                    Button("Number Field") {
                        newWidgetType = .numberFieldWidget
                    }
                    
                    // Add TextEditorWidget to section
                    Button("Text Editor") {
                        newWidgetType = .textEditorWidget
                    }
                    
                    // Add DropdownSectionWidget to section
                    Button("Dropdown Menu") {
                        newWidgetType = .dropdownSectionWidget
                    }
                    
                    // Add CheckboxSectionWidget to section
                    Button("Checkboxes") {
                        newWidgetType = .checkboxSectionWidget
                    }
                    
                    // Add MapWidget to section
                    Button("Map") {
                        newWidgetType = .mapWidget
                    }
                    
                    // Add PhotoLibraryWidget to section
                    Button("Photo Library") {
                        newWidgetType = .photoLibraryWidget
                    }
                    
                    // Add CanvasWidget to section
                    Button("Canvas") {
                        newWidgetType = .canvasWidget
                    }
                } label: {
                    Image(systemName: "plus.circle")
                }
                .sheet(item: $newWidgetType) { newWidgetType in
                    NewWidgetView(newWidgetType: $newWidgetType, section: section)
                }
            }
            
            // Display all widgets in section
            List() {
                ForEach(section.widgetsArray) { widget in
                    let widgetType: WidgetType = WidgetType.init(rawValue: widget.type!)!
                    
                    switch widgetType {
                    case .textFieldWidget:
                        let textFieldWidget = widget as! TextFieldWidget
                        TextFieldWidgetView(textFieldWidget: textFieldWidget)
                        
                    case .numberFieldWidget:
                        let numberFieldWidget = widget as! NumberFieldWidget
                        NumberFieldWidgetView(numberFieldWidget: numberFieldWidget)
                        
                    case .textEditorWidget:
                        let textEditorWidget = widget as! TextEditorWidget
                        TextEditorWidgetView(textEditorWidget: textEditorWidget)
                        
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
        SectionView(section: dev.form.sectionsArray.first!, newWidgetType: nil)
    }
}
