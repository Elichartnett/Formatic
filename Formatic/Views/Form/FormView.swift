//
//  FormView.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/29/22.
//

import SwiftUI

// Displays a form with title and sections
struct FormView: View {
    
    @Environment(\.editMode) var editMode
    @FetchRequest var sections: FetchedResults<Section>
    @ObservedObject var form: Form
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
                .background(Color(uiColor: .systemGray6))
            
            // Display all section in form
            if !forPDF {
                // List is used for user visibility due to built in support for swipe gestures and lazy loading. Can not be used for pdf because there is no finite height due to lazy loading. Without a finite height, the view is not rendered properly when exporting view as pdf.
                if sections.isEmpty {
                    Color(uiColor: .systemGray6)
                }
                else {
                    List {
                        ForEach(sections) { section in
                            SwiftUI.Section {
                                SectionView(section: section, locked: $form.locked, forPDF: forPDF)
                            } header: {
                                HStack {
                                    SectionTitleView(section: section, locked: $form.locked, sectionTitle: section.title ?? "")
                                    
                                    Button {
                                        FormModel.deleteSection(section: section)
                                    } label: {
                                        Image(systemName: "trash")
                                            .customIcon()
                                            .opacity(editMode?.wrappedValue == .active ? 1 : 0)
                                    }
                                }
                            }
                            .headerProminence(.increased)
                        }
                    }
                }
            }
            
            else {
                // ScrollView is used in place of list when exporting to pdf because it has a finite height so the full view can be rendered without scrolling. Modifiers added to make scrollview look like list
                ScrollView {
                    if sections.isEmpty {
                        
                    }
                    else {
                        ForEach(sections) { section in
                            SwiftUI.Section {
                                VStack {
                                    SectionView(section: section, locked: $form.locked, forPDF: forPDF)
                                        .padding(.top, 10)
                                        .padding(.bottom, 10)
                                        .padding(.horizontal, 20)
                                        .background(.white)
                                }
                                .background(.white)
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
                .background(Color(uiColor: .systemGray6))
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
                        EditorViewToolbar(form: dev.form, exportToForm: .constant(false), exportToPDF: .constant(false), exportToCSV: .constant(false), showToggleLockView: .constant(false), editMode: .constant(.inactive))
                    }
                })
                .environmentObject(FormModel())
        }
        .navigationViewStyle(.stack)
    }
}
