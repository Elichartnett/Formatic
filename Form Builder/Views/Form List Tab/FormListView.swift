//
//  FormListView.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/28/22.
//

import SwiftUI

struct FormListView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var forms: FetchedResults<Form>
    
    @EnvironmentObject var formModel: FormModel
    
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                // List of all saved forms
                List() {
                    ForEach(forms) { form in
                        Text(form.title)
                            .onTapGesture {
                                formModel.activeForm = form
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
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ListViewToolbar()
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
