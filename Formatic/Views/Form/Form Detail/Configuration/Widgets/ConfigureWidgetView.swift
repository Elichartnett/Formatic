//
//  ConfigureWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/3/22.
//
import SwiftUI

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
            
            InputBox(placeholder: Strings.titleLabel, text: $widgetTitle)
            
            switch newWidgetType {
            case .textFieldWidget:
                ConfigureTextFieldWidgetView(title: $widgetTitle, section: section)
                    .onAppear {
                        typeTitle = Strings.textFieldLabel
                    }
                
            case .numberFieldWidget:
                ConfigureNumberFieldWidgetView(title: $widgetTitle, section: section)
                    .onAppear {
                        typeTitle = Strings.numberFieldLabel
                    }
                
            case .dropdownSectionWidget:
                ConfigureDropdownSectionWidgetView(title: $widgetTitle, section: section)
                    .onAppear {
                        typeTitle = Strings.dropdownMenuLabel
                    }
                
                // Will be handled in section
            case .dropdownWidget:
                EmptyView()
                
            case .checkboxSectionWidget:
                ConfigureCheckboxSectionWidgetView(title: $widgetTitle, section: section)
                    .onAppear {
                        typeTitle = Strings.checkboxMenuLabel
                    }
                
                // Will be handled in section
            case .checkboxWidget:
                EmptyView()
                
            case .mapWidget:
                ConfigureMapWidgetView(title: $widgetTitle, section: section)
                    .onAppear {
                        typeTitle = Strings.mapLabel
                    }
                
            case .canvasWidget:
                ConfigureCanvasWidgetView(title: $widgetTitle, section: section)
                    .onAppear {
                        typeTitle = Strings.canvasLabel
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
