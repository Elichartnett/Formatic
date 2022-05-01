//
//  FormListView.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/28/22.
//

import SwiftUI

// List of all saved forms with list toolbar
struct FormListView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var forms: FetchedResults<Form>
    
    @EnvironmentObject var formModel: FormModel
    
    @State var showNewFormView: Bool = false
    @State var showImportFormView: Bool = false
    
    var body: some View {
        
        NavigationView {
            
            List() {
                ForEach(forms) { form in
                    NavigationLink {
                        FormEditorView(form: form)
                    } label: {
                        Text(form.title ?? "")
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let form = forms[index]
                        moc.delete(form)
                        DataController.saveMOC()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ListViewToolbar(showNewFormView: $showNewFormView, showImportFormView: $showImportFormView)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct FormListView_Previews: PreviewProvider {
    static var previews: some View {
        FormListView()
            .environment(\.managedObjectContext, DataController.shared.container.viewContext)
            .environmentObject(FormModel())
    }
}
