//
//  SectionTitleView.swift
//  Form Builder
//
//  Created by Eli Hartnett on 5/4/22.
//

import SwiftUI

struct SectionTitleView: View {
    
    @ObservedObject var section: Section
    
    @State var newWidgetType: WidgetType?
    @State var sectionTitle: String = ""
    
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
                    .font(Font.body)
            }
            
            TextField("Section title", text: $sectionTitle)
                .font(Font.title.weight(.semibold))
                .onChange(of: sectionTitle) { newValue in
                    section.title = sectionTitle
                }
        }
        .textCase(.none)
        .onAppear {
            sectionTitle = section.title ?? ""
        }
    }
}

struct SectionTitleView_Previews: PreviewProvider {
    static var previews: some View {
        SectionTitleView(section: dev.section)
    }
}
