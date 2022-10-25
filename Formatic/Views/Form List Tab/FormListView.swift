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
    @State var sortMethod = SortMethod.defaultOrder
    @State var showAlert = false
    @State var alertTitle = ""
    @State var alertButtonDismissMessage = "Okay"
    
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
                                        alertTitle = Strings.deleteFormErrorMessage
                                        showAlert = true
                                    }
                                } label: {
                                    Label(Strings.deleteLabel, systemImage: Strings.trashIconName)
                                }
                                .tint(.red)
                                
                                Button {
                                    do {
                                        try formModel.copyForm(form: form)
                                    }
                                    catch {
                                        alertTitle = Strings.copyFormErrorMessage
                                        showAlert = true
                                    }
                                } label: {
                                    Label(Strings.copyLabel, systemImage: Strings.copyIconName)
                                }
                                .tint(.blue)
                            }
                        }
                    }
                    .searchable(text: $searchText, placement: .toolbar)
                    .onChange(of: searchText, perform: { _ in
                        if searchText == "" {
                            filteredForms.nsPredicate = nil
                        }
                        else {
                            filteredForms.nsPredicate = NSPredicate(format: "title CONTAINS %@", searchText)
                        }
                    })
                    .onChange(of: sortMethod, perform: { _ in
                        UserDefaults.standard.set(sortMethod.rawValue, forKey: Strings.sortMethodUserDefaultsKey)
                        switch sortMethod {
                        case .defaultOrder:
                            filteredForms.nsSortDescriptors = []
                        case .alphabetical:
                            filteredForms.nsSortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
                        }
                    })
                    .overlay {
                        if filteredForms.isEmpty {
                            Text(Strings.noSearchResultsMessage)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color(uiColor: UIColor.systemGray6).ignoresSafeArea())
                        }
                    }
                }
                else {
                    Text(Strings.getStartedMessage)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(uiColor: UIColor.systemGray6).ignoresSafeArea())
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ListViewToolbar(showNewFormView: $showNewFormView, showImportFormView: $showImportFormView, showSortMethodMenu: !forms.isEmpty, sortMethod: $sortMethod)
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
                        alertTitle = Strings.importFormErrorMessage
                        showAlert = true
                    }
                case .failure(_):
                    alertTitle = Strings.importFormErrorMessage
                    showAlert = true
                }
            }
            .onOpenURL { url in
                do {
                    try formModel.importForm(url: url)
                }
                catch {
                    alertTitle = Strings.importFormErrorMessage
                    showAlert = true
                }
            }
            .alert(alertTitle, isPresented: $showAlert, actions: {
                Button(alertButtonDismissMessage, role: .cancel) {}
            })
        }
        .navigationViewStyle(.stack)
        .onAppear {
            if let method = UserDefaults.standard.object(forKey: Strings.sortMethodUserDefaultsKey) as? String {
                sortMethod = SortMethod(rawValue: method) ?? SortMethod.defaultOrder
            }
        }
    }
}

struct FormListView_Previews: PreviewProvider {
    static var previews: some View {
        FormListView()
            .environment(\.managedObjectContext, DataControllerModel.shared.container.viewContext)
            .environmentObject(FormModel())
    }
}
