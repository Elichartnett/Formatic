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
    @State var selectedWidgets: [Widget] = []
    var forPDF: Bool
    
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
                    List {
                        ForEach(sections) { section in
                            SwiftUI.Section {
                                SectionView(section: section, locked: $form.locked, selectedWidgets: $selectedWidgets, forPDF: forPDF)
                            } header: {
                                HStack {
                                    SectionTitleView(section: section, locked: $form.locked, sectionTitle: section.title ?? "")
                                    Button {
                                        withAnimation {
                                            for widget in selectedWidgets {
                                                formModel.deleteWidget(widget: widget)
                                            }
                                            selectedWidgets.removeAll()
                                            editMode?.wrappedValue = .inactive
                                        }
                                    } label: {
                                        Image(systemName: Strings.trashIconName)
                                            .customIcon()
                                            .opacity(editMode?.wrappedValue == .active && !selectedWidgets.isEmpty ? 1 : 0)
                                            .animation(.default, value: selectedWidgets.isEmpty)
                                    }
                                }
                            }
                            .headerProminence(.increased)
                        }
                        .onChange(of: editMode?.wrappedValue) { mode in
                            if mode == .inactive {
                                selectedWidgets.removeAll()
                            }
                        }
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
                                    SectionView(section: section, locked: $form.locked, selectedWidgets: $selectedWidgets, forPDF: forPDF)
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
                        EditorViewToolbar(form: dev.form, showToggleLockView: .constant(false), editMode: .constant(.inactive))
                    }
                })
                .environmentObject(FormModel())
                .environment(\.managedObjectContext, DataControllerModel.shared.container.viewContext)
        }
        .navigationViewStyle(.stack)
    }
}
