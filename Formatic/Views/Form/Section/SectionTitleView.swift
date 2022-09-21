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
                
                // Add CanvasWidget to section
                Button("Canvas") {
                    newWidgetType = .canvasWidget
                }
            } label: {
                Image(systemName: "plus.circle")
            }
            
            TextField("Section title", text: $sectionTitle)
                .focused($sectionTitleIsFocused)
                .font(Font.title.weight(.semibold))
                .onChange(of: sectionTitle) { newValue in
                    section.title = sectionTitle
                }
                .onChange(of: sectionTitleIsFocused) { newValue in
                    DataControllerModel.saveMOC()
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
