//
//  FormListView.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/28/22.
//

import SwiftUI

// List of all saved forms with list toolbar
struct FormListView: View {
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.position)]) var forms: FetchedResults<Form>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.position)]) var filteredForms: FetchedResults<Form>
    @EnvironmentObject var formModel: FormModel
    @State var searchText = ""
    @State var showNewFormView = false
    @State var showImportFormView = false
    @State var showAlert = false
    @State var alertTitle = ""
    @State var alertButtonTitle = "Okay"
    
    var body: some View {
        
        NavigationView {
            
            Group {
                if !forms.isEmpty {
                    
                    List {
                        
                        ForEach(filteredForms) { form in
                            
                            NavigationLink {
                                FormEditorView(form: form)
                            } label: {
                                Text(form.title ?? "")
                            }
                            .swipeActions {
                                Button {
                                    do {
                                        try formModel.deleteForm(position: Int(form.position))
                                    }
                                    catch {
                                        
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.red)
                                
                                Button {
                                    do {
                                        try formModel.copyForm(form: form)
                                    }
                                    catch {
                                        
                                    }
                                } label: {
                                    Label("Copy", systemImage: "doc.on.doc")
                                }
                                .tint(.blue)
                            }
                        }
                    }
                    .searchable(text: $searchText, placement: .navigationBarDrawer)
                    .onChange(of: searchText, perform: { _ in
                        if searchText == "" {
                            filteredForms.nsPredicate = nil
                        }
                        else {
                            filteredForms.nsPredicate = NSPredicate(format: "title CONTAINS %@", searchText)
                        }
                    })
                    .overlay {
                        if filteredForms.isEmpty {
                            Text("No results. Try searching for a different form title.")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color(uiColor: UIColor.systemGray6).ignoresSafeArea())
                        }
                    }
                }
                else {
                    Text("Add a form to get started!")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(uiColor: UIColor.systemGray6).ignoresSafeArea())
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ListViewToolbar(showNewFormView: $showNewFormView, showImportFormView: $showImportFormView)
                }
            }
            .sheet(isPresented: $showNewFormView) {
                NewFormView(showNewFormView: $showNewFormView)
            }
            .fileImporter(isPresented: $showImportFormView, allowedContentTypes: [.form]) { result in
                switch result {
                case .success(let url):
                    do {
                        try formModel.importForm(url: url)
                    }
                    catch {
                        alertTitle = "Error importing form"
                        showAlert = true
                    }
                case .failure(_):
                    alertTitle = "Error importing form"
                    showAlert = true
                }
            }
            .onOpenURL { url in
                do {
                    try formModel.importForm(url: url)
                }
                catch {
                    alertTitle = "Error importing form"
                    showAlert = true
                }
            }
            .alert(alertTitle, isPresented: $showAlert, actions: {
                Button(alertButtonTitle, role: .cancel) {}
            })
        }
        .navigationViewStyle(.stack)
    }
}

struct FormListView_Previews: PreviewProvider {
    static var previews: some View {
        FormListView()
            .environment(\.managedObjectContext, DataControllerModel.shared.container.viewContext)
            .environmentObject(FormModel())
    }
}
