//
//  ConfigureWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/3/22.
//

import SwiftUI

// Sheet to configure new widget
struct NewWidgetView: View {
    
    @Binding var newWidgetType: WidgetType?
    @ObservedObject var section: Section
    @State var typeTitle: String = ""
    @State var widgetTitle: String = ""
    
    var body: some View {
        
        VStack {
            
            Text(typeTitle)
                .font(.title)
                .bold()
                .padding(.top)
            
            InputBox(placeholder: "Title", text: $widgetTitle)
            
            switch newWidgetType {
            case .textFieldWidget:
                NewTextFieldWidgetView(newWidgetType: $newWidgetType, title: $widgetTitle, section: section)
                    .onAppear {
                        typeTitle = "Text Field"
                    }
                
            case .numberFieldWidget:
                NewNumberFieldWidgetView(newWidgetType: $newWidgetType, title: $widgetTitle, section: section)
                    .onAppear {
                        typeTitle = "Number Field"
                    }
                
            case .textEditorWidget:
                NewTextEditorWidgetView(newWidgetType: $newWidgetType, title: $widgetTitle, section: section)
                    .onAppear {
                        typeTitle = "Text Editor"
                    }
                
            case .dropdownSectionWidget:
                NewDropdownSectionWidgetView(newWidgetType: $newWidgetType, title: $widgetTitle, section: section)
                    .onAppear {
                        typeTitle = "Dropdown Menu"
                    }
                // Will be displayed in case .dropdownSectionWidget
            case .dropdownWidget:
                EmptyView()
                
            case .checkboxSectionWidget:
                NewCheckboxSectionWidgetView(newWidgetType: $newWidgetType, title: $widgetTitle, section: section)
                    .onAppear {
                        typeTitle = "Checkboxes"
                    }
                
                // Will be displayed in case .checkboxSectionWidget
            case .checkboxWidget:
                EmptyView()
                
            case .mapWidget:
                NewMapWidgetView(newWidgetType: $newWidgetType, title: $widgetTitle, section: section)
                    .onAppear {
                        typeTitle = "Map"
                    }
                
            case .photoLibraryWidget:
                NewPhotoLibraryWidgetView(newWidgetType: $newWidgetType, title: $widgetTitle, section: section)
                    .onAppear {
                        typeTitle = "Photo Library"
                    }
                // Will be displayed in case .photoLibraryWidget
            case .photoWidget:
                EmptyView()
                
            case .canvasWidget:
                NewCanvasWidgetView(newWidgetType: $newWidgetType, title: $widgetTitle, section: section)
                    .onAppear {
                        typeTitle = "Canvas"
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
        NewWidgetView(newWidgetType: .constant(.textFieldWidget), section: dev.section)
    }
}
