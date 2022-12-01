//
//  DropdownSectionWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct DropdownSectionWidgetView: View {
    
    @Environment(\.editMode) var editMode
    @EnvironmentObject var formModel: FormModel
    @FetchRequest var dropdowns: FetchedResults<DropdownWidget>
    
    @ObservedObject var dropdownSectionWidget: DropdownSectionWidget
    @Binding var locked: Bool
    @State var reconfigureWidget = false
    @State var title: String
    
    init(dropdownSectionWidget: DropdownSectionWidget, locked: Binding<Bool>) {
        self._dropdowns = FetchRequest<DropdownWidget>(sortDescriptors: [SortDescriptor(\.position)], predicate: NSPredicate(format: Constants.predicateDropdownSectionWidgetEqualTo, dropdownSectionWidget))
        self.dropdownSectionWidget = dropdownSectionWidget
        self._locked = locked
        self._title = State(initialValue: dropdownSectionWidget.title ?? "")
    }
    
    var body: some View {
        
        let baseView = Group {
            
            let reconfigureButton = Button {
                reconfigureWidget = true
            } label: {
                Image(systemName: Constants.editIconName)
                    .customIcon()
                    .opacity(editMode?.wrappedValue == .active ? 1 : 0)
            }
                .disabled(editMode?.wrappedValue == .inactive)
                .transition(.asymmetric(insertion: .push(from: .trailing), removal: .push(from: .leading)))
            
            Group {
                HStack {
                    InputBox(placeholder: Strings.titleLabel, text: $title)
                        .titleFrameStyle(locked: $locked)
                        .onChange(of: title) { _ in
                            dropdownSectionWidget.title = title
                        }
                    
                    if formModel.isPhone {
                        reconfigureButton
                    }
                }
                
                HStack {
                    
                    dropDownMenuButton
                    
                    Text(dropdownSectionWidget.selectedDropdown?.title ?? Strings.noSelectionLabel)
                }
                .frame(maxWidth: .infinity)
                .WidgetFrameStyle()
                
                if !formModel.isPhone && editMode?.wrappedValue == .active {
                    reconfigureButton
                }
            }
            .sheet(isPresented: $reconfigureWidget) {
                ConfigureDropdownSectionWidgetView(dropdownSectionWidget: dropdownSectionWidget, title: $title, section: dropdownSectionWidget.section!)
                    .padding()
            }
            // Manually setting list row inset to 0 for bug where divider does not go all the way across row
            .alignmentGuide(.listRowSeparatorLeading, computeValue: { viewDimensions in
                return viewDimensions[.listRowSeparatorLeading]
            })
        }
        
        if formModel.isPhone {
            VStack(alignment: .leading, spacing: Constants.stackSpacingConstant) {
                baseView
            }
        }
        else {
            HStack(spacing: Constants.stackSpacingConstant) {
                baseView
            }
        }
    }
    
    var dropDownMenuButton: some View {
        Menu {
            ForEach(dropdowns) { widget in
                Button {
                    dropdownSectionWidget.selectedDropdown = widget
                } label: {
                    HStack {
                        Text(widget.title!)
                        Spacer()
                        if dropdownSectionWidget.selectedDropdown == widget {
                            Image(systemName: Constants.checkmarkIconName)
                        }
                    }
                }
            }
        } label: {
            Text(Strings.dropdownMenuLabel)
                .foregroundColor(.blue)
        }
    }
}

struct DropdownSectionWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        DropdownSectionWidgetView(dropdownSectionWidget: dev.dropdownSectionWidget, locked: .constant(false))
            .environmentObject(FormModel())
    }
}
