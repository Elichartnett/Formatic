//
//  DropdownSectionWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct DropdownSectionWidgetView: View {
    
    @FetchRequest var dropdowns: FetchedResults<DropdownWidget>
    @ObservedObject var dropdownSectionWidget: DropdownSectionWidget
    @Environment(\.editMode) var editMode
    @Binding var locked: Bool
    @State var reconfigureWidget = false
    @State var title: String
    
    init(dropdownSectionWidget: DropdownSectionWidget, locked: Binding<Bool>) {
        self._dropdowns = FetchRequest<DropdownWidget>(sortDescriptors: [SortDescriptor(\.position)], predicate: NSPredicate(format: "dropdownSectionWidget == %@", dropdownSectionWidget))
        self.dropdownSectionWidget = dropdownSectionWidget
        self._locked = locked
        self._title = State(initialValue: dropdownSectionWidget.title ?? "")
    }
    
    var body: some View {
        
        HStack {
            
            InputBox(placeholder: "Title", text: $title)
                .titleFrameStyle(locked: $locked)
                .onChange(of: title) { _ in
                    dropdownSectionWidget.title = title
                }
            
            Spacer()
            
            HStack {
                
                Menu {
                    ForEach(dropdowns) { widget in
                        Button {
                            dropdownSectionWidget.selectedDropdown = widget
                            DataControllerModel.saveMOC()
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
            
            Button {
                reconfigureWidget = true
            } label: {
                if editMode?.wrappedValue == .active {
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .foregroundColor(.black)
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                }
            }
            .disabled(editMode?.wrappedValue == .inactive)
        }
        .ignoresSafeArea()
        .sheet(isPresented: $reconfigureWidget) {
            ConfigureDropdownSectionWidgetView(dropdownSectionWidget: dropdownSectionWidget, title: $title, section: dropdownSectionWidget.section!)
                .padding()
        }
    }
}

struct DropdownSectionWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        DropdownSectionWidgetView(dropdownSectionWidget: dev.dropdownSectionWidget, locked: .constant(false))
    }
}
