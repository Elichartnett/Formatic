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
        
        if FormModel.isPhone {
            VStack(alignment: .leading) {
                BaseDropdownSectionWidgetView(dropdownSectionWidget: dropdownSectionWidget, locked: $locked)
            }
        }
        else {
            HStack {
                BaseDropdownSectionWidgetView(dropdownSectionWidget: dropdownSectionWidget, locked: $locked)
            }
        }
    }
}

struct DropdownSectionWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        DropdownSectionWidgetView(dropdownSectionWidget: dev.dropdownSectionWidget, locked: .constant(false))
    }
}

struct BaseDropdownSectionWidgetView: View {
    
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
        Group {
            
            let reconfigureButton = Button {
                reconfigureWidget = true
            } label: {
                if editMode?.wrappedValue == .active {
                    Image(systemName: Strings.editIconName)
                        .customIcon()
                }
            }
                .disabled(editMode?.wrappedValue == .inactive)
            
            HStack {
                InputBox(placeholder: Strings.titleLabel, text: $title)
                    .titleFrameStyle(locked: $locked)
                    .onChange(of: title) { _ in
                        dropdownSectionWidget.title = title
                    }
                
                if FormModel.isPhone {
                    reconfigureButton
                }
            }
            .padding(.bottom, 1)
            
            HStack {
                Spacer()
                
                Menu {
                    ForEach(dropdowns) { widget in
                        Button {
                            dropdownSectionWidget.selectedDropdown = widget
                        } label: {
                            HStack {
                                Text(widget.title!)
                                Spacer()
                                if dropdownSectionWidget.selectedDropdown == widget {
                                    Image(systemName: Strings.checkmarkIconName)
                                }
                            }
                        }
                    }
                } label: {
                    Text(Strings.dropdownMenuLabel)
                        .foregroundColor(.blue)
                }
                
                Text(dropdownSectionWidget.selectedDropdown?.title! ?? Strings.noSelectionLabel)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .WidgetFrameStyle()
            
            if !FormModel.isPhone {
                reconfigureButton
            }
        }
        .sheet(isPresented: $reconfigureWidget) {
            ConfigureDropdownSectionWidgetView(dropdownSectionWidget: dropdownSectionWidget, title: $title, section: dropdownSectionWidget.section!)
                .padding()
        }
        // Manually setting list row inset to 0
        .alignmentGuide(.listRowSeparatorLeading, computeValue: { viewDimensions in
            return viewDimensions[.listRowSeparatorLeading]
        })
    }
}
