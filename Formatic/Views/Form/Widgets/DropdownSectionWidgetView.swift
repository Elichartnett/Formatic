//
//  DropdownSectionWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct DropdownSectionWidgetView: View {
    
    @ObservedObject var dropdownSectionWidget: DropdownSectionWidget
    @Binding var locked: Bool
    @State var title: String = ""
    
    var body: some View {
        
        HStack {
            
            InputBox(placeholder: "Title", text: $title)
                .titleFrameStyle(locked: $locked)
                .onChange(of: title) { _ in
                    dropdownSectionWidget.title = title
                }
                .onAppear {
                    title = dropdownSectionWidget.title ?? ""
                }
            
            Spacer()
            
            HStack {

                Menu {
                    ForEach(dropdownSectionWidget.dropdownsArray) { widget in
                        Button {
                            dropdownSectionWidget.selectedDropdown = widget
                            DataController.saveMOC()
                        } label: {
                            HStack {
                                Text(widget.title!)
                                Spacer()
                                if dropdownSectionWidget.selectedDropdown == widget {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    Text("Dropdown Menu:")
                }

                Text(dropdownSectionWidget.selectedDropdown?.title! ?? "No selection")
            }
            
            Spacer()
        }
    }
}

struct DropdownSectionWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        DropdownSectionWidgetView(dropdownSectionWidget: dev.dropdownSectionWidget, locked: .constant(false))
    }
}
