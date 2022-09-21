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
    @EnvironmentObject var formModel: FormModel
    
    @State var showNewFormView = false
    @State var showImportFormView = false
    @State var showAlert = false
    @State var alertTitle = ""
    @State var alertButtonTitle = "Okay"
    
    var body: some View {
        
        NavigationView {
            
            List {
                
                ForEach(forms) { form in
                    
                    NavigationLink {
                        FormEditorView(form: form)
                    } label: {
                        Text(form.title ?? "")
                    }
                }
                .onDelete { indexSet in
                    do {
                        try formModel.deleteFormWithIndexSet(indexSet: indexSet)
                    }
                    catch {
                        alertTitle = "Error deleting form"
                        showAlert = true
                    }
                }
            }
            .overlay {
                if forms.isEmpty {
                    Text("Add a form to get started!")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(uiColor: UIColor.systemGray6))
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
