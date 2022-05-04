//
//  ConfigureWidgetView.swift
//  Form Builder
//
//  Created by Eli Hartnett on 5/3/22.
//

import SwiftUI

// Sheet to configure new widget
struct NewWidgetView: View {
    
    @Binding var newWidgetType: WidgetType?
    @ObservedObject var section: Section
    @State var type: String = ""
    @State var title: String = ""
    @State var widget = Widget(title: nil, position: Int16(1), type: WidgetType.textFieldWidget.rawValue)
    
    var body: some View {
        
        VStack {
            
            Text(type)
                .font(.title)
                .bold()
            
            InputBox(placeholder: "Title", text: $title)
            
            switch newWidgetType {
            case .textFieldWidget:
                NewTextFieldWidgetView(newWidgetType: $newWidgetType, title: $title, section: section)
                    .onAppear {
                        type = "Text Field"
                    }
                
            case .numberFieldWidget:
                NewNumberFieldWidgetView(newWidgetType: $newWidgetType, title: $title, section: section)
                    .onAppear {
                        type = "Number Field"
                    }
                
            case .textEditorWidget:
                NewTextEditorWidgetView()
                    .onAppear {
                        type = "Text Editor"
                    }
                
                // Will be displayed in case .dropdownSectionWidget
            case .dropdownWidget:
                EmptyView()
                
            case .dropdownSectionWidget:
                NewDropdownSectionWidgetView()
                    .onAppear {
                        type = "Dropdown Menu"
                    }
                
                // Will be displayed in case .checkboxSectionWidget
            case .checkboxWidget:
                EmptyView()
                
            case .checkboxSectionWidget:
                NewCheckboxSectionWidgetView()
                    .onAppear {
                        type = "Checkboxes"
                    }
                
            case .mapWidget:
                NewMapWidgetView()
                    .onAppear {
                        type = "Map"
                    }
                
            case .photoLibraryWidget:
                NewPhotoLibraryWidgetView()
                    .onAppear {
                        type = "Photo Library"
                    }
                
            case .canvasWidget:
                NewCanvasWidgetView()
                    .onAppear {
                        type = "Canvas"
                    }
                
            case .none:
                EmptyView()
            }
        }
        .padding(.horizontal)
    }
}

struct ConfigureWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        NewWidgetView(newWidgetType: .constant(dev.newWidgetType), section: dev.section)
    }
}
