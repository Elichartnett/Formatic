//
//  DropdownSectionWidgetView.swift
// Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct DropdownSectionWidgetView: View {
    
    @ObservedObject var dropdownWidgetSection: DropdownSectionWidget
    @Binding var locked: Bool
    @State var title: String = ""
    
    var body: some View {
        
        HStack {
            
            InputBox(placeholder: "Title", text: $title)
                .titleFrameStyle()
                .onChange(of: title) { _ in
                    dropdownWidgetSection.title = title
                }
                .disabled(locked)
            
            Spacer()
            
            HStack {
                
                Menu {
                    ForEach(dropdownWidgetSection.dropdownsArray) { widget in
                        Button {
                            dropdownWidgetSection.selectedDropdown = widget
                            DataController.saveMOC()
                        } label: {
                            HStack {
                                Text(widget.title!)
                                Spacer()
                                if dropdownWidgetSection.selectedDropdown == widget {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    Text("Dropdown Menu:")
                }
                
                Text(dropdownWidgetSection.selectedDropdown?.title! ?? "No selection")
            }
            
            Spacer()
        }
    }
}

struct DropdownSectionWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        DropdownSectionWidgetView(dropdownWidgetSection: dev.dropdownSectionWidget, locked: .constant(false))
    }
}
