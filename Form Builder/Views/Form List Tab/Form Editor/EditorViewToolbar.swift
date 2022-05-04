//
//  EditorViewToolbar.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/29/22.
//

import SwiftUI

// Tool bar options for editing a form
struct EditorViewToolbar: View {
    
    @ObservedObject var form: Form
    @Binding var showExportToPDFView: Bool
    @Binding var showExportToTemplateView: Bool
    
    var body: some View {
        
        HStack {
            
            Spacer()
            
            // Lock form button
            Button {
                form.locked.toggle()
            } label: {
                HStack {
                    Image(systemName: form.locked == true ? "lock" : "lock.open")
                    Text(form.locked == true ? "Locked" : "Unlocked")
                }
            }
            .disabled(form.password?.isEmpty ?? true)
            
            Spacer()
            
            // Add section to form button
            Button {
                form.addToSections(Section(title: nil))
                DataController.saveMOC()
            } label: {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("New section")
                }
            }
            .disabled(form.locked)
            
            Spacer()
            
            // Export form button
            Menu {
                
                // Export to PDF button
                Button {
                    showExportToPDFView = true
                } label: {
                    HStack {
                        Image(systemName: "doc.text.image")
                        Text("PDF")
                    }
                }
                
                // Export to template button
                Button {
                    showExportToTemplateView = true
                } label: {
                    HStack {
                        Image(systemName: "doc.zipper")
                        Text("Template")
                    }
                }

            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Export")
                }
            }
            .disabled(form.locked)
            
            Spacer()
        }
    }
}

struct EditorViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        EditorViewToolbar(form: dev.form, showExportToPDFView: .constant(false), showExportToTemplateView: .constant(false))
    }
}
