//
//  FormView.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/29/22.
//

import SwiftUI

struct FormDetailView: View {
    
    @EnvironmentObject var formModel: FormModel
    @Environment(\.editMode) var editMode
    @FetchRequest var sections: FetchedResults<Section>
    
    @ObservedObject var form: Form
    var forPDF: Bool
    @State var selectedWidgets = Set<Widget>()
    @State var selectedSections = Set<Section>()
    @State var showToggleLockView = false
    @State var sortSections = false
    
    init(form: Form, forPDF: Bool) {
        self._sections = FetchRequest<Section>(sortDescriptors: [SortDescriptor(\.position)], predicate: NSPredicate(format: Constants.predicateFormEqualTo, form))
        self.form = form
        self.forPDF = forPDF
    }
    
    var body: some View {
        
        VStack (spacing: 0) {
            
            FormTitleView(form: form, formTitle: form.title)
                .padding(.horizontal)
                .background(Color.primaryBackground)
            
            // List is used for user visibility due to built in support for swipe gestures and lazy loading. Can not be used for pdf because there is no finite height due to lazy loading. Without a finite height, the view is not rendered properly when exporting view as pdf.
            if sections.isEmpty {
                Color.primaryBackground.ignoresSafeArea()
            }
            else {
                if !forPDF {
                    
                    List(sections, selection: $selectedWidgets) { section in
                        
                        let sectionSelected = editMode?.wrappedValue == .active && (selectedWidgets.contains(where: { selectedWidget in
                            section.widgets?.contains(selectedWidget) ?? false
                        }) || selectedSections.contains(section))
                        
                        SwiftUI.Section {
                            SectionView(section: section, locked: $form.locked, forPDF: forPDF)
                        } header: {
                            HStack {
                                if editMode?.wrappedValue == .active {
                                    Button {
                                        withAnimation {
                                            if selectedSections.contains(section) {
                                                for widget in section.sortedWidgetsArray() {
                                                    selectedWidgets.remove(widget)
                                                }
                                                selectedSections.remove(section)
                                            }
                                            else {
                                                for widget in section.sortedWidgetsArray() {
                                                    selectedWidgets.insert(widget)
                                                }
                                                selectedSections.insert(section)
                                            }
                                        }
                                    } label: {
                                        Image(systemName: selectedSections.contains(section) ? Constants.filledCircleCheckmarkIconName : Constants.circleIconName)
                                            .customIcon()
                                    }
                                }
                                
                                SectionTitleView(section: section, locked: $form.locked, sectionTitle: section.title ?? "")
                                
                                MultiWidgetSelectionToolBar(section: section, selectedSections: $selectedSections, selectedWidgets: $selectedWidgets)
                                    .opacity(sectionSelected ? 1 : 0)
                                    .animation(.default, value: selectedWidgets.isEmpty)
                                    .accessibility(hidden: !sectionSelected)
                                
                                Button {
                                    sortSections.toggle()
                                } label: {
                                    Group {
                                        if formModel.isPhone {
                                            Labels.move.labelStyle(.iconOnly)
                                        }
                                        else {
                                            Labels.move.labelStyle(.titleAndIcon)
                                        }
                                    }
                                    .opacity(editMode?.wrappedValue == .active ? 1 : 0)
                                    .accessibility(hidden: editMode?.wrappedValue != .active)
                                }
                            }
                        }
                        .id(Int(section.position))
                        .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                            return -20
                        }
                        .listSectionSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .padding(.horizontal)
                    .scrollContentBackground(.hidden)
                    .scrollDismissesKeyboard(.interactively)
                    .background(Color.primaryBackground)
                    .onChange(of: editMode?.wrappedValue) { mode in
                        if mode == .inactive {
                            selectedSections.removeAll()
                        }
                    }
                    .onChange(of: form.sections?.hashValue) { _ in
                        resolvePositions()
                    }
                }
                else {
                    // ScrollView is used in place of list when exporting to pdf because it has a finite height so the full view can be rendered without scrolling. Modifiers added to make scrollview look like list
                    ScrollView {
                        if sections.isEmpty {
                            Color.primaryBackground.ignoresSafeArea()
                        }
                        else {
                            ForEach(sections) { section in
                                SwiftUI.Section {
                                    VStack (spacing: 0) {
                                        SectionView(section: section, locked: $form.locked, forPDF: forPDF)
                                            .padding(.vertical, 10)
                                            .padding(.horizontal, 20)
                                            .background(Color.secondaryBackground).ignoresSafeArea()
                                    }
                                } header: {
                                    SectionTitleView(section: section, locked: $form.locked, sectionTitle: section.title ?? "")
                                        .padding(.top)
                                        .padding(.bottom, 10)
                                }
                                .headerProminence(.increased)
                            }
                        }
                    }
                    .padding()
                    .background(Color.primaryBackground.ignoresSafeArea())
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                FormDetailViewToolbar(form: form, showToggleLockView: $showToggleLockView)
            }
            
            FormaticToolbar()
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showToggleLockView, onDismiss: {
            if form.locked == true {
                withAnimation {
                    editMode?.wrappedValue = .inactive
                }
            }
        }, content: {
            ToggleLockView(showToggleLockView: $showToggleLockView, form: form)
        })
        .sheet(isPresented: $sortSections) {
            VStack(spacing: 0) {
                EditModeButton(activeOnAppear: true) { }
                    .padding(.top)
                
                if !(form.sections?.isEmpty ?? true) {
                    List {
                        ForEach(sections) { section in
                            if form.sections?.contains(section) ?? false {
                                Text(section.title ?? "")
                                    .swipeActions {
                                        Button {
                                            section.delete()
                                        } label: {
                                            Labels.delete
                                        }
                                        .tint(.red)
                                        
                                        Button {
                                            let copy = section.createCopy() as! Section
                                            copy.position = section.position + 1
                                            
                                            for index in Int(copy.position)..<sections.count {
                                                sections[index].position += 1
                                            }
                                            
                                            copy.form = section.form
                                        } label: {
                                            Labels.copy
                                        }
                                        .tint(.blue)
                                    }
                            }
                        }
                        .onMove(perform: { indexSet, destination in
                            form.updateSectionPositions(indexSet: indexSet, destination: destination)
                        })
                    }
                    .scrollContentBackground(.hidden)
                }
                else {
                    Color.primaryBackground
                }
            }
            .background(Color.primaryBackground)
            .onChange(of: form.sections?.isEmpty) { isEmpty in
                if isEmpty ?? true {
                    sortSections = false
                    editMode?.wrappedValue = .inactive
                }
            }
        }
    }
    
    func resolvePositions() {
        for (index, section) in form.sortedSectionsArray().enumerated() {
            section.position = Int16(index)
        }
        try? DataControllerModel.saveMOC()
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FormDetailView(form: dev.form, forPDF: false)
                .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        FormDetailViewToolbar(form: dev.form, showToggleLockView: .constant(false))
                    }
                })
                .environmentObject(FormModel())
                .environment(\.managedObjectContext, DataControllerModel.shared.container.viewContext)
        }
        .navigationViewStyle(.stack)
    }
}

private struct MultiWidgetSelectionToolBar: View {
    
    @EnvironmentObject var formModel: FormModel
    @Environment(\.editMode) var editMode
    
    let section: Section
    @Binding var selectedSections: Set<Section>
    @Binding var selectedWidgets: Set<Widget>
    
    var body: some View {
        
        HStack {
            Button {
                withAnimation {
                    if selectedSections.contains(section) {
                        guard let sections = section.form?.sortedSectionsArray() else { return }
                        
                        let copy = section.createCopy() as! Section
                        copy.position = section.position + 1
                        
                        for index in Int(copy.position)..<sections.count {
                            sections[index].position += 1
                        }
                        
                        copy.form = section.form
                        selectedSections.remove(section)
                    }
                    else {
                        for widget in section.sortedWidgetsArray() {
                            if selectedWidgets.contains(widget) {
                                widget.initiateCopy()
                            }
                        }
                    }
                    removeAllWidgetsFromSelection()
                }
            } label: {
                let label = Labels.copy
                
                if formModel.isPhone {
                    label.labelStyle(.iconOnly)
                }
                else {
                    label
                }
            }
            
            Button {
                withAnimation {
                    if selectedSections.contains(section) {
                        section.delete()
                    }
                    else {
                        for widget in section.sortedWidgetsArray() {
                            if selectedWidgets.contains(widget) {
                                widget.delete()
                            }
                        }
                    }
                    removeAllWidgetsFromSelection()
                }
            } label: {
                let label = Labels.delete
                    .foregroundColor(.red)
                
                if formModel.isPhone {
                    label.labelStyle(.iconOnly)
                }
                else {
                    label
                }
            }
        }
    }
    
    func removeAllWidgetsFromSelection() {
        for widget in section.sortedWidgetsArray() {
            selectedWidgets.remove(widget)
        }
    }
}
