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
            Button(Strings.textFieldLabel) {
                newWidgetType = .textFieldWidget
            }
            
            Button(Strings.numberFieldLabel) {
                newWidgetType = .numberFieldWidget
            }
            
            Button(Strings.dropdownMenuLabel) {
                newWidgetType = .dropdownSectionWidget
            }
            
            Button(Strings.checkboxMenuLabel) {
                newWidgetType = .checkboxSectionWidget
            }
            
            Button(Strings.mapLabel) {
                newWidgetType = .mapWidget
            }
            
            Button(Strings.canvasLabel) {
                newWidgetType = .canvasWidget
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
