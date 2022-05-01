//
//  SectionView.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/29/22.
//

import SwiftUI

struct SectionView: View {
    
    @State var section: Section
    
    var body: some View {
        
        VStack {
            
            Text(section.title ?? "")
            
            ForEach(section.widgetsArray) { widget in
                let widgetType: WidgetType = WidgetType.init(rawValue: widget.type ?? "") ?? .unknown
                                
                switch widgetType {
                case .textFieldWidget:
                    let textFieldWidget = widget as! TextFieldWidget
                    Text(textFieldWidget.title ?? "")
                    Text(textFieldWidget.text ?? "")
                    
                case .numberFieldWidget:
                    let numberFieldWidget = widget as! NumberFieldWidget
                    Text("Number Field")
                    
                case .textEditorWidget:
                    let textEditorWidget = widget as! TextEditorWidget
                    Text("Text Editor")
                    
                case .dropdownSectionWidget:
                    let dropdownSectionWidget = widget as! DropdownSectionWidget
                    Text("Dropdown")
                    
                case .checkboxSectionWidget:
                    let checkboxSectionWidget = widget as! CheckboxSectionWidget
                    Text("Checkbox")
                    
                case .mapWidget:
                    let mapWidget = widget as! MapWidget
                    Text("Map")
                    
                case .photoLibraryWidget:
                    let photoLibraryWidget = widget as! PhotoLibraryWidget
                    Text("Photo Library")
                    
                case .canvasWidget:
                    let canvasWidget = widget as! CanvasWidget
                    Text("Canvas")
                    
                case .unknown:
                    Text("unknown")
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
