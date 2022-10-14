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
    @State var newWidgetType: WidgetType? {
        didSet {
            configureNewWidget = true
        }
    }
    @State var sectionTitle: String
    @State var configureNewWidget = false
    
    init(section: Section, locked: Binding<Bool>, sectionTitle: String) {
        self.section = section
        self._locked = locked
        self.sectionTitle = sectionTitle
    }
    
    var body: some View {
        
        // Section title and add widget menu
        HStack {
            
            Menu {
                // Add TextFieldWidget to section
                Button(Strings.textFieldLabel) {
                    newWidgetType = .textFieldWidget
                }
                
                // Add NumberFieldWidget to section
                Button(Strings.numberFieldLabel) {
                    newWidgetType = .numberFieldWidget
                }
                
                // Add TextEditorWidget to section
                Button(Strings.textEditorLabel) {
                    newWidgetType = .textEditorWidget
                }
                
                // Add DropdownSectionWidget to section
                Button(Strings.numberFieldLabel) {
                    newWidgetType = .dropdownSectionWidget
                }
                
                // Add CheckboxSectionWidget to section
                Button(Strings.checkboxesLabel) {
                    newWidgetType = .checkboxSectionWidget
                }
                
                // Add MapWidget to section
                Button(Strings.mapLabel) {
                    newWidgetType = .mapWidget
                }
                
                // Add CanvasWidget to section
                Button(Strings.canvasLabel) {
                    newWidgetType = .canvasWidget
                }
            } label: {
                Image(systemName: Strings.plusCircleIconName)
            }
            
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
                .font(Font.body)
        }
    }
}

struct SectionTitleView_Previews: PreviewProvider {
    static var previews: some View {
        SectionTitleView(section: dev.section, locked: .constant(dev.form.locked), sectionTitle: dev.section.title ?? "")
    }
}
