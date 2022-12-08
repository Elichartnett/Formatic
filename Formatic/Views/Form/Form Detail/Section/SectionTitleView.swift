//
//  SectionTitleView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/4/22.
//

import SwiftUI

struct SectionTitleView: View {
    
    @ObservedObject var section: Section
    @Binding var locked: Bool
    @FocusState var sectionTitleIsFocused: Bool
    @State var sectionTitle: String
    @State var configureNewWidget = false
    @State var newWidgetType: WidgetType? {
        didSet {
            configureNewWidget = true
        }
    }
    
    init(section: Section, locked: Binding<Bool>, sectionTitle: String) {
        self.section = section
        self._locked = locked
        self.sectionTitle = sectionTitle
    }
    
    var body: some View {
        
        HStack {
            
            addWidgetMenu
            
            TextField(Strings.sectionTitleLabel, text: $sectionTitle)
                .focused($sectionTitleIsFocused)
                .font(Font.title.weight(.semibold))
                .onChange(of: sectionTitle) { newValue in
                    section.title = sectionTitle
                }
        }
        .disabled(locked)
        .textCase(.none)
        .sheet(isPresented: $configureNewWidget) {
            ConfigureWidgetView(newWidgetType: newWidgetType!, section: section)
                .textCase(.none)
        }
    }
    
    var addWidgetMenu: some View {
        Menu {
            ForEach(WidgetType.allCases) { widgetType in
                switch widgetType {
                case .textFieldWidget:
                    Button(Strings.textFieldLabel) {
                        newWidgetType = .textFieldWidget
                    }
                    
                case .numberFieldWidget:
                    Button(Strings.numberFieldLabel) {
                        newWidgetType = .numberFieldWidget
                    }
                    
                case .dateFieldWidget:
                    Button(Strings.dateFieldLabel) {
                        newWidgetType = .dateFieldWidget
                    }

                case .sliderWidget:
                    Button(Strings.sliderLabel) {
                        newWidgetType = .sliderWidget
                    }
                case .dropdownSectionWidget:
                    Button(Strings.dropdownMenuLabel) {
                        newWidgetType = .dropdownSectionWidget
                    }
                    
                case .dropdownWidget:
                    EmptyView()

                case .checkboxSectionWidget:
                    Button(Strings.checkboxMenuLabel) {
                        newWidgetType = .checkboxSectionWidget
                    }
                    
                case .checkboxWidget:
                    EmptyView()
                    
                case .mapWidget:
                    Button(Strings.mapLabel) {
                        newWidgetType = .mapWidget
                    }

                case .canvasWidget:
                    Button(Strings.canvasLabel) {
                        newWidgetType = .canvasWidget
                    }
                }
            }
        } label: {
            Image(systemName: Constants.plusCircleIconName)
        }
    }
}

struct SectionTitleView_Previews: PreviewProvider {
    static var previews: some View {
        SectionTitleView(section: dev.section, locked: .constant(dev.form.locked), sectionTitle: dev.section.title ?? "")
    }
}
