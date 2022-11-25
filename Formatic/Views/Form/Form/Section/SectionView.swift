//
//  SectionView.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/29/22.
//

import SwiftUI

// Displays form sections with section titles and widgets
struct SectionView: View {
    
    @Environment(\.editMode) var editMode
    @EnvironmentObject var formModel: FormModel
    @FetchRequest var widgets: FetchedResults<Widget>
    @ObservedObject var section: Section
    @Binding var locked: Bool
    var forPDF: Bool
    var moveDisabled: Bool {
        return locked
    }
    
    init(section: Section, locked: Binding<Bool>, forPDF: Bool = false) {
        self._widgets = FetchRequest<Widget>(sortDescriptors: [SortDescriptor(\.position)], predicate: NSPredicate(format: "section == %@", section))
        self.section = section
        self._locked = locked
        self.forPDF = forPDF
    }
    
    var body: some View {
        
        if widgets.isEmpty {
            // Empty view representing section - used as work around for vertical spacing issue when adding multiple sections at once without any widgets in the section
            Color.clear
                .frame(height: forPDF ? 45 : 1)
                .cornerRadius(10)
        }
        else {
            // Display all widgets in section
            ForEach(widgets, id: \.self) { widget in
                HStack {
                    let widgetType: WidgetType = WidgetType.init(rawValue: widget.type!)!
                    Group {
                        switch widgetType {
                        case .textFieldWidget:
                            if let textFieldWidget = widget as? TextFieldWidget {
                                TextFieldWidgetView(textFieldWidget: textFieldWidget, locked: $locked)
                            }
                            
                        case .numberFieldWidget:
                            let numberFieldWidget = widget as! NumberFieldWidget
                            NumberFieldWidgetView(numberFieldWidget: numberFieldWidget, locked: $locked)
                            
                        case .dropdownSectionWidget:
                            let dropdownSectionWidget = widget as! DropdownSectionWidget
                            DropdownSectionWidgetView(dropdownSectionWidget: dropdownSectionWidget, locked: $locked)
                            
                            // Will be handled in section
                        case .dropdownWidget:
                            EmptyView()
                            
                        case .checkboxSectionWidget:
                            let checkboxSectionWidget = widget as! CheckboxSectionWidget
                            CheckboxSectionWidgetView(checkboxSectionWidget: checkboxSectionWidget, locked: $locked)
                            
                            // Will be handled in section
                        case .checkboxWidget:
                            EmptyView()
                            
                        case .mapWidget:
                            let mapWidget = widget as! MapWidget
                            MapWidgetView(mapWidget: mapWidget, locked: $locked, forPDF: forPDF)
                            
                        case .canvasWidget:
                            let canvasWidget = widget as! CanvasWidget
                            CanvasWidgetView(canvasWidget: canvasWidget, locked: $locked)
                        }
                    }
                    .swipeActions {
                        if !locked {
                            Button {
                                formModel.deleteWidget(widget: widget)
                            } label: {
                                Label(Strings.deleteLabel, systemImage: Strings.trashIconName)
                            }
                            .tint(.red)
                            
                            Button {
                                formModel.copyWidget(section: section, widget: widget)
                            } label: {
                                Label(Strings.copyLabel, systemImage: Strings.copyIconName)
                            }
                            .tint(.blue)
                        }
                    }
                }
                
                if forPDF && widget != widgets[widgets.count - 1] {
                    Divider()
                }
            }
            .onMove(perform: { indexSet, destination in
                formModel.updateWidgetPosition(section: section, indexSet: indexSet, destination: destination)
            })
            .moveDisabled(moveDisabled)
        }
    }
}

struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SectionView(section: (dev.form.sections!.first)!, locked: .constant(dev.form.locked))
                .environmentObject(FormModel())
        }
    }
}
