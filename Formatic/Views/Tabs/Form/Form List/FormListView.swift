//
//  FormListView.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/28/22.
//

import SwiftUI

// List of all saved forms with list toolbar
struct FormListView: View {
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.dateCreated)]) var forms: FetchedResults<Form>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.dateCreated)]) var filteredForms: FetchedResults<Form>
    @EnvironmentObject var formModel: FormModel
    @State var searchText = ""
    @State var showNewFormView = false
    @State var showImportFormView = false
    @State var importingForm = false
    @State var sortMethod = SortMethod.dateCreated
    @State var showSettingsMenu = false
    @State var showAlert = false
    @State var alertTitle = ""
    @State var alertButtonDismissMessage = "Okay"
    
    var body: some View {
        
        NavigationStack {
            
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
                                        try formModel.deleteForm(id: form.id)
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
                    .scrollDismissesKeyboard(.interactively)
                    .onChange(of: searchText, perform: { _ in
                        if searchText == "" {
                            filteredForms.nsPredicate = nil
                        }
                        else {
                            filteredForms.nsPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
                        }
                    })
                    .onChange(of: sortMethod, perform: { _ in
                        updateFilteredForms()
                    })
                    .overlay {
                        if filteredForms.isEmpty {
                            Text(Strings.noSearchResultsMessage)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.primaryBackground).ignoresSafeArea()
                        }
                    }
                }
                else {
                    Text(Strings.getStartedMessage)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.primaryBackground).ignoresSafeArea()
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.primaryBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ListViewToolbar(showNewFormView: $showNewFormView, showImportFormView: $showImportFormView, showSortMethodMenu: !forms.isEmpty, sortMethod: $sortMethod, showSettingsMenu: $showSettingsMenu)
                }
            }
            .sheet(isPresented: $showNewFormView) {
                NewFormView(showNewFormView: $showNewFormView)
            }
            .sheet(isPresented: $showSettingsMenu, content: {
                SettingsView()
            })
            .fileImporter(isPresented: $showImportFormView, allowedContentTypes: [.form]) { result in
                switch result {
                case .success(let url):
                    DispatchQueue.main.async {
                        importingForm = true
                        do {
                            try formModel.importForm(url: url)
                        }
                        catch {
                            alertTitle = Strings.importFormErrorMessage
                            showAlert = true
                        }
                        importingForm = false
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
            .overlay {
                if importingForm {
                    ProgressView()
                }
            }
            .alert(alertTitle, isPresented: $showAlert, actions: {
                Button(alertButtonDismissMessage, role: .cancel) {}
            })
        }
        .navigationViewStyle(.stack)
    }
    
    func updateFilteredForms() {
        switch sortMethod {
        case .dateCreated:
            filteredForms.nsSortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: true)]
        case .alphabetical:
            filteredForms.nsSortDescriptors = [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))]
        }
    }
}

struct FormListView_Previews: PreviewProvider {
    static var previews: some View {
        FormListView(sortMethod: .dateCreated)
            .environment(\.managedObjectContext, DataControllerModel.shared.container.viewContext)
            .environmentObject(FormModel())
    }
}
