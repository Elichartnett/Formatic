//
//  FormView.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/29/22.
//

import SwiftUI

// Displays a form with title and sections
struct FormView: View {
    
    @EnvironmentObject var formModel: FormModel
    @Environment(\.editMode) var editMode
    @FetchRequest var sections: FetchedResults<Section>
    @ObservedObject var form: Form
    var forPDF: Bool
    @State var selectedWidgets = Set<Widget>()
    
    init(form: Form, forPDF: Bool) {
        self._sections = FetchRequest<Section>(sortDescriptors: [SortDescriptor(\.position)], predicate: NSPredicate(format: "form == %@", form))
        self.form = form
        self.forPDF = forPDF
    }
    
    var body: some View {
        
        VStack (spacing: 0) {
            
            FormTitleView(form: form, formTitle: form.title)
                .padding(.horizontal)
                .background(Color.primaryBackground)
            
            // Display all section in form
            if !forPDF {
                // List is used for user visibility due to built in support for swipe gestures and lazy loading. Can not be used for pdf because there is no finite height due to lazy loading. Without a finite height, the view is not rendered properly when exporting view as pdf.
                if sections.isEmpty {
                    Color.primaryBackground.ignoresSafeArea()
                }
                else {
                    List(sections, selection: $selectedWidgets) { section in
                        SwiftUI.Section {
                            SectionView(section: section, locked: $form.locked, forPDF: forPDF)
                        } header: {
                            HStack {
                                SectionTitleView(section: section, locked: $form.locked, sectionTitle: section.title ?? "")
                                
                                Button {
                                    withAnimation {
                                        for widget in selectedWidgets {
                                            if section.widgets?.contains(widget) ?? false {
                                                formModel.copyWidget(section: section, widget: widget)
                                            }
                                        }
                                        selectedWidgets.removeAll()
                                    }
                                } label: {
                                    Image(systemName: Strings.copyIconName)
                                        .foregroundColor(.blue)
                                        .opacity(editMode?.wrappedValue == .active && (selectedWidgets.contains(where: { selectedWidget in
                                            section.widgets?.contains(selectedWidget) ?? false
                                        })) ? 1 : 0)
                                }
                                
                                Button {
                                    withAnimation {
                                        for widget in selectedWidgets {
                                            if section.widgets?.contains(widget) ?? false {
                                                formModel.deleteWidget(widget: widget)
                                            }
                                        }
                                        selectedWidgets.removeAll()
                                    }
                                } label: {
                                    Image(systemName: Strings.trashIconName)
                                        .foregroundColor(.red)
                                        .opacity(editMode?.wrappedValue == .active && (selectedWidgets.contains(where: { selectedWidget in
                                            section.widgets?.contains(selectedWidget) ?? false
                                        })) ? 1 : 0)
                                }
                            }
                            .onChange(of: editMode?.wrappedValue) { mode in
                                if mode == .inactive {
                                    selectedWidgets.removeAll()
                                }
                            }
                        }
                        .headerProminence(.increased)
                    }
                    .scrollContentBackground(.hidden)
                    .scrollDismissesKeyboard(.interactively)
                    .background(Color.primaryBackground)
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
                                        .padding(.top, 10)
                                        .padding(.bottom, 10)
                                        .padding(.horizontal, 20)
                                        .background(Color.secondaryBackground).ignoresSafeArea()
                                }
                                .cornerRadius(10)
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
                .background(Color.primaryBackground).ignoresSafeArea()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FormView(form: dev.form, forPDF: false)
                .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        EditorViewToolbar(form: dev.form, showToggleLockView: .constant(false))
                    }
                })
                .environmentObject(FormModel())
                .environment(\.managedObjectContext, DataControllerModel.shared.container.viewContext)
        }
        .navigationViewStyle(.stack)
    }
}
