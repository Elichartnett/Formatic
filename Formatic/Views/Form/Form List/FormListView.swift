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
    
    @AppStorage(Constants.numberFormsSettingsStorageKey) var numberForms = false
    @FetchRequest(sortDescriptors: [SortDescriptor(\.dateCreated)], predicate: NSPredicate(format: Constants.predicateRecentlyDeletedEqualToFalse)) var forms: FetchedResults<Form>
    @EnvironmentObject var formModel: FormModel
    
    @State var filteredForms = [Form]()
    @State var selectedForms = Set<Form>()
    @State var exportType: UTType?
    @State var showExportView = false
    @State var showMultiFormSelectionToolBar = false
    @State var searchText = Constants.emptyString
    @State var showNewFormView = false
    @State var importCount = "1"
    @State var currentFormURL: URL?
    @State var showImportFormView = false
    @State var importingForm = false
    @State var sortMethod = SortMethod.dateCreated
    @State var showSettingsMenu = false
    @State var showPaywallView = false
    @State var showImportAlert = false
    @State var showAlert = false
    @State var alertTitle = Constants.emptyString
    @State var alertButtonDismissMessage = Strings.defaultAlertButtonDismissMessage
    var sortedSelectedForm: [Form] {
        selectedForms.sorted(by: {
            sortMethod == .dateCreated ? $0.dateCreated < $1.dateCreated : $0.title ?? Constants.emptyString < $1.title ?? Constants.emptyString })
    }
    
    var body: some View {
        
        Group {
            if !forms.isEmpty {
                VStack {
                    if showMultiFormSelectionToolBar {
                        multiFormSelectionToolBar
                            .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
                    }
                    
                    List(filteredForms, id: \.self, selection: $selectedForms) { form in
                        Button {
                            formModel.navigationPath.append(form)
                        } label: {
                            Text("\(numberForms ? ((forms.firstIndex(of: form) ?? 0).description + ". ") : Constants.emptyString)\(form.title ?? Constants.emptyString)")
                                .foregroundColor(.primary)
                        }
                        .swipeActions {
                            SwipeActions(form: form)
                        }
                    }
                    .searchable(text: $searchText, placement: .navigationBarDrawer)
                    .scrollDismissesKeyboard(.interactively)
                    .navigationDestination(for: Form.self, destination: { form in
                        FormDetailView(form: form, forPDF: false)
                    })
                    .onAppear {
                        filteredForms.removeAll()
                        for form in forms {
                            filteredForms.append(form)
                        }
                    }
                    .onChange(of: selectedForms.isEmpty, perform: { isEmpty in
                        withAnimation {
                            showMultiFormSelectionToolBar = !isEmpty
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
                                let title = form.title ?? Constants.emptyString
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
                .accessibilityLabel(Strings.formsLabel)
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
        .sheet(isPresented: $showPaywallView, content: {
            PaywallView(storeKitManager: formModel.storeKitManager)
        })
        .fileImporter(isPresented: $showImportFormView, allowedContentTypes: [.form]) { result in
            switch result {
            case .success(let url):
                currentFormURL = url
                showImportAlert = true
            case .failure(_):
                alertTitle = Strings.importFormErrorMessage
                showAlert = true
            }
        }
        .onOpenURL { url in
            if formModel.storeKitManager.purchasedProducts.contains(where: { product in
                product.id == FormaticProductID.pro.rawValue
            }) {
                currentFormURL = url
                showImportAlert = true
            }
            else {
                showPaywallView = true
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
        .alert(alertTitle, isPresented: $showImportAlert, actions: {
            TextField(Strings.importCount, text: $importCount)
                .keyboardType(.numberPad)
            
            Button(Strings.importLabel) { importForm() }
            Button(alertButtonDismissMessage, role: .cancel) {}
        })
    }
    
    var multiFormSelectionToolBar: some View {
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
                let label = Labels.copy
                if formModel.isPhone {
                    label.labelStyle(.iconOnly)
                }
                else {
                    label
                }
            }
            
            Spacer()
            
            Button {
                for form in selectedForms {
                    form.initiateReset()
                }
                selectedForms.removeAll()
            } label: {
                let label = Labels.reset
                if formModel.isPhone {
                    label.labelStyle(.iconOnly)
                }
                else {
                    label
                }
            }
            .tint(.yellow)
            
            Spacer()
            
            Button {
                for form in selectedForms {
                    form.recentlyDeleted = true
                }
                selectedForms.removeAll()
                showMultiFormSelectionToolBar = false
            } label: {
                let label = Labels.delete
                if formModel.isPhone {
                    label.labelStyle(.iconOnly)
                }
                else {
                    label
                }
            }
            
            Spacer()
            
            ExportMenuButton(storeKitManager: formModel.storeKitManager, exportType: $exportType, forms: sortedSelectedForm)
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
    
    func importForm() {
        DispatchQueue.main.async {
            importingForm = true
        }
        do {
            if let currentFormURL, let count = Int(importCount) {
                for _ in 1...count {
                    try Form.importForm(url: currentFormURL)
                }
            }
            else {
                alertTitle = Strings.importFormErrorMessage
                showAlert = true
            }
        }
        catch {
            alertTitle = Strings.importFormErrorMessage
            showAlert = true
        }
        DispatchQueue.main.async {
            importingForm = false
        }
        
        importCount = "1"
    }
    
    struct SwipeActions: View {
        
        @ObservedObject var form: Form
        
        var body: some View {
            Button {
                form.recentlyDeleted = true
            } label: {
                Labels.delete
            }
            .tint(.red)
            
            Button {
                form.initiateReset()
            } label: {
                Labels.reset
            }
            .tint(.yellow)
            
            Button {
                let _ = form.createCopy()
            } label: {
                Labels.copy
            }
            .tint(.blue)
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
