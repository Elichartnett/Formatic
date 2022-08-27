//
//  ConfigureWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/3/22.
//

import SwiftUI

// Sheet to configure new widget
struct ConfigureWidgetView: View {
    
    let newWidgetType: WidgetType
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
                ConfigureTextFieldWidgetView(title: $widgetTitle, section: section)
                    .onAppear {
                        typeTitle = "Text Field"
                    }
                
            case .numberFieldWidget:
                ConfigureNumberFieldWidgetView(title: $widgetTitle, section: section)
                    .onAppear {
                        typeTitle = "Number Field"
                    }
                
            case .textEditorWidget:
                ConfigureTextEditorWidgetView(title: $widgetTitle, section: section)
                    .onAppear {
                        typeTitle = "Text Editor"
                    }
                
            case .dropdownSectionWidget:
                ConfigureDropdownSectionWidgetView(title: $widgetTitle, section: section)
                    .onAppear {
                        typeTitle = "Dropdown Menu"
                    }
                // Will be displayed in case .dropdownSectionWidget
            case .dropdownWidget:
                EmptyView()
                
            case .checkboxSectionWidget:
                ConfigureCheckboxSectionWidgetView(title: $widgetTitle, section: section)
                    .onAppear {
                        typeTitle = "Checkboxes"
                    }
                
                // Will be displayed in case .checkboxSectionWidget
            case .checkboxWidget:
                EmptyView()
                
            case .mapWidget:
                ConfigureMapWidgetView(title: $widgetTitle, section: section)
                    .onAppear {
                        typeTitle = "Map"
                    }
                
            case .canvasWidget:
                ConfigureCanvasWidgetView(title: $widgetTitle, section: section)
                    .onAppear {
                        typeTitle = "Canvas"
                    }
            }
        }
        .padding(.horizontal)
    }
}

struct ConfigureWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureWidgetView(newWidgetType: .textFieldWidget, section: dev.section)
    }
}
