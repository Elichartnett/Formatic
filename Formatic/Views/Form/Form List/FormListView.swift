//
//  FormListView.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/28/22.
//

import SwiftUI
import CoreData
import UniformTypeIdentifiers

struct FormListView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.dateCreated)], predicate: NSPredicate(format: Constants.predicateRecentlyDeletedEqualToFalse)) var forms: FetchedResults<Form>
    @EnvironmentObject var formModel: FormModel
    
    @State var filteredForms = [Form]()
    @State var selectedForms = Set<Form>()
    @State var exportType: UTType?
    @State var showExportView = false
    @State var showMultiSelectionToolbar = false
    @State var searchText = ""
    @State var showNewFormView = false
    @State var showImportFormView = false
    @State var importingForm = false
    @State var sortMethod = SortMethod.dateCreated
    @State var showSettingsMenu = false
    @State var showAlert = false
    @State var alertTitle = ""
    @State var alertButtonDismissMessage = Strings.defaultAlertButtonDismissMessage
    var sortedSelectedForm: [Form] {
        selectedForms.sorted(by: {
            sortMethod == .dateCreated ? $0.dateCreated < $1.dateCreated : $0.title ?? "" < $1.title ?? "" })
    }
    
    var body: some View {
        
        Group {
            if !forms.isEmpty {
                VStack {
                    if showMultiSelectionToolbar {
                        multiSelectionToolbar
                            .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
                    }
                    
                    List(filteredForms, id: \.self, selection: $selectedForms) { form in
                        Button {
                            formModel.navigationPath.append(form)
                        } label: {
                            Text(form.title ?? "")
                                .foregroundColor(.primary)
                        }
                        .swipeActions {
                            Button {
                                form.recentlyDeleted = true
                            } label: {
                                Labels.delete
                            }
                            .tint(.red)
                            
                            Button {
                                let _ = form.createCopy()
                            } label: {
                                Labels.copy
                            }
                            .tint(.blue)
                        }
                    }
                    .searchable(text: $searchText, placement: .navigationBarDrawer)
                    .scrollDismissesKeyboard(.interactively)
                    .navigationDestination(for: Form.self, destination: { form in
                        FormEditorView(form: form)
                    })
                    .onAppear {
                        filteredForms.removeAll()
                        for form in forms {
                            filteredForms.append(form)
                        }
                    }
                    .onChange(of: selectedForms.isEmpty, perform: { isEmpty in
                        withAnimation {
                            showMultiSelectionToolbar = !isEmpty
                        }
                    })
                    .onChange(of: forms.count, perform: { _ in // Force list update - refresh bug when canceling search and adding form
                        filteredForms.removeAll()
                        for form in forms {
                            filteredForms.append(form)
                        }
                    })
                    .onChange(of: searchText, perform: { _ in
                        filteredForms.removeAll()
                        for form in forms {
                            if searchText.isEmpty {
                                if !form.recentlyDeleted { filteredForms.append(form) }
                            }
                            else {
                                let title = form.title ?? ""
                                if !form.recentlyDeleted && title.contains(searchText) { filteredForms.append(form) }
                            }
                        }
                    })
                    .onChange(of: sortMethod, perform: { _ in
                        updateFilteredForms()
                        filteredForms.removeAll()
                        for form in forms {
                            filteredForms.append(form)
                        }
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
                ListViewToolbar(showNewFormView: $showNewFormView, showSortMethodMenu: !forms.isEmpty, sortMethod: $sortMethod, showImportFormView: $showImportFormView, showSettingsMenu: $showSettingsMenu)
            }
        }
        .sheet(isPresented: $showNewFormView, content: {
            NewFormView(showNewFormView: $showNewFormView)
        })
        .sheet(isPresented: $showSettingsMenu, content: {
            SettingsView()
        })
        .sheet(isPresented: $showExportView, onDismiss: {
            exportType = nil
        }, content: {
            ExportView(forms: sortedSelectedForm, exportType: $exportType)
        })
        .fileImporter(isPresented: $showImportFormView, allowedContentTypes: [.form]) { result in
            switch result {
            case .success(let url):
                DispatchQueue.main.async {
                    importingForm = true
                    do {
                        try Form.importForm(url: url)
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
                try Form.importForm(url: url)
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
    
    var multiSelectionToolbar: some View {
        HStack {
            Spacer()
            
            Button {
                withAnimation {
                    for form in selectedForms {
                        let _ = form.createCopy()
                    }
                    selectedForms.removeAll()
                }
            } label: {
                Image(systemName: Constants.copyIconName)
                    .customIcon()
            }
            
            Spacer()
            
            Button {
                for form in selectedForms {
                    form.recentlyDeleted = true
                }
                selectedForms.removeAll()
            } label: {
                Image(systemName: Constants.trashIconName)
                    .foregroundColor(.red)
            }
            
            Spacer()
            
            ExportMenuButton(exportType: $exportType, forms: sortedSelectedForm)
                .onChange(of: exportType) { _ in
                    if exportType != nil { showExportView = true }
                }
            
            Spacer()
        }
        
    }
    
    func updateFilteredForms() {
        switch sortMethod {
        case .dateCreated:
            forms.nsSortDescriptors = [NSSortDescriptor(key: Constants.sortDescriptorDateCreated, ascending: true)]
        case .alphabetical:
            forms.nsSortDescriptors = [NSSortDescriptor(key: Constants.sortDescriptorTitle, ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))]
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
