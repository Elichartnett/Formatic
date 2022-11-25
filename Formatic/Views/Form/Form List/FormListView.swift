//
//  FormListView.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/28/22.
//

import SwiftUI
import CoreData

// List of all saved forms with list toolbar
struct FormListView: View {
    
    @Environment(\.editMode) var editMode
    @FetchRequest(sortDescriptors: [SortDescriptor(\.dateCreated)], predicate: NSPredicate(format: "recentlyDeleted != true")) var forms: FetchedResults<Form>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.dateCreated)], predicate: NSPredicate(format: "recentlyDeleted != true")) var filteredForms: FetchedResults<Form>
    @EnvironmentObject var formModel: FormModel
    @State var selectedForms = Set<Form>()
    @State var showSelectionToolbar = false
    @State var searchText = ""
    @State var showNewFormView = false
    @State var showImportFormView = false
    @State var importingForm = false
    @State var sortMethod = SortMethod.dateCreated
    @State var showSettingsMenu = false
    @State var showAlert = false
    @State var alertTitle = ""
    @State var alertButtonDismissMessage = Strings.defaultAlertButtonDismissMessage
    
    var body: some View {
        
        NavigationStack(path: $formModel.navigationPath) {
            
            Group {
                if !forms.isEmpty {
                    VStack {
                        if showSelectionToolbar {
                            HStack {
                                Spacer()
                                Button {
                                    for form in selectedForms {
                                        do {
                                            try formModel.copyForm(form: form)
                                        }
                                        catch {
                                            alertTitle = Strings.copyFormErrorMessage
                                            showAlert = true
                                        }
                                    }
                                    selectedForms.removeAll()
                                } label: {
                                    Image(systemName: Strings.copyIconName)
                                        .foregroundColor(.blue)
                                }
                                
                                Spacer()
                                
                                Button {
                                    for form in selectedForms {
                                        form.recentlyDeleted = true
                                    }
                                    selectedForms.removeAll()
                                } label: {
                                    Image(systemName: Strings.trashIconName)
                                        .foregroundColor(.red)
                                }
                                
                                Spacer()
                                
                                Button {
                                    
                                } label: {
                                    Image(systemName: Strings.exportMultipleFormsIconName)
                                        .foregroundColor(.blue)
                                }
                                
                                Spacer()
                            }
                            .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
                        }
                        
                        List(filteredForms, id: \.self, selection: $selectedForms) { form in
                            
                            Button {
                                formModel.navigationPath.append(form)
                            } label: {
                                Text(form.title ?? "")
                                    .foregroundColor(.primary)
                                    .swipeActions {
                                        Button {
                                            form.recentlyDeleted = true
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
                        .searchable(text: $searchText, placement: .navigationBarDrawer)
                        .scrollDismissesKeyboard(.interactively)
                        .navigationDestination(for: Form.self, destination: { form in
                            FormEditorView(form: form)
                        })
                        .onChange(of: selectedForms.isEmpty, perform: { isEmpty in
                            withAnimation {
                                showSelectionToolbar = !isEmpty
                            }
                        })
                        .onChange(of: searchText, perform: { _ in
                            if searchText == "" {
                                filteredForms.nsPredicate = NSPredicate(format: "recentlyDeleted != %@", "true")
                            }
                            else {
                                filteredForms.nsPredicate = NSPredicate(format: "title CONTAINS[cd] %@ AND recentlyDeleted != %@", searchText, "true")
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
