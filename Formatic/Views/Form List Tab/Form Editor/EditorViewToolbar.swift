//
//  EditorViewToolbar.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/29/22.
//

import SwiftUI

// Tool bar options for editing a form
struct EditorViewToolbar: View {
    
    @ObservedObject var form: Form
    @Binding var exportToTemplate: Bool
    @Binding var showToggleLockView: Bool
    @Binding var isEditing: Bool
    
    var body: some View {
        
        HStack {
            
            Group {
                Spacer()
                
                // Lock and unlock form button
                Button {
                    if form.locked || (!form.locked && form.password == nil) {
                        showToggleLockView = true
                    }
                    else  {
                        form.locked = true
                    }
                } label: {
                    HStack {
                        Image(systemName: form.locked == true ? "lock" : "lock.open")
                        Text(form.locked == true ? "Locked" : "Unlocked")
                    }
                }
            }
            
            Group {
                Spacer()
                
                // Add section to form button
                Button {
                    form.addToSections(Section(position: form.sections?.count ?? 0, title: nil))

                    DataController.saveMOC()
                } label: {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("New section")
                    }
                }
                .disabled(form.locked)
            }
            
            Group {
                Spacer()
                
                // Enable edit mode to rearrange list of widgets
                Button {
                    withAnimation {
                        isEditing.toggle()
                    }
                } label: {
                    HStack {
                        Image(systemName: "slider.horizontal.3")
                        Text(isEditing ? "Done" : "Edit")
                    }
                }
                .disabled(form.locked)
            }
            
            Group {
                Spacer()
                
                // Save form in managed object context button
                Button {
                    DataController.saveMOC()
                } label: {
                    Text("Save")
                }
            }
            
            Group {
                Spacer()
                
                // Export form button
                Menu {
                    
                    // Export to template button
                    Button {
                        exportToTemplate = true
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
                
                Spacer()
            }
        }
    }
}

struct EditorViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        EditorViewToolbar(form: dev.form, exportToTemplate: .constant(false), showToggleLockView: .constant(false), isEditing: .constant(false))
    }
}
