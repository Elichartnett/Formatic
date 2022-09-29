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
    
    init(section: Section, locked: Binding<Bool>, forPDF: Bool = false) {
        self._widgets = FetchRequest<Widget>(sortDescriptors: [SortDescriptor(\.position)], predicate: NSPredicate(format: "section == %@", section))
        self.section = section
        self._locked = locked
        self.forPDF = forPDF
    }
    
    var body: some View {
        
        // Display all widgets in section
        ForEach(widgets) { widget in
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
                    
                case .textEditorWidget:
                    let textEditorWidget = widget as! TextEditorWidget
                    TextEditorWidgetView(textEditorWidget: textEditorWidget, locked: $locked)
                    
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
                    MapWidgetView(mapWidget: mapWidget, locked: $locked)
                    
                case .canvasWidget:
                    let canvasWidget = widget as! CanvasWidget
                    CanvasWidgetView(canvasWidget: canvasWidget, locked: $locked)
                }
            }
            .swipeActions {
                Button {
                    formModel.deleteWidget(section: section, position: Int(widget.position))
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .tint(.red)
                
                Button {
                    formModel.copyWidget(section: section, widget: widget)
                } label: {
                    Label("Copy", systemImage: "doc.on.doc")
                }
                .tint(.blue)
            }
            
            if forPDF && widget != widgets[widgets.count - 1] {
                Divider()
            }
        }
        .onMove(perform: { indexSet, destination in
            formModel.updateWidgetPosition(section: section, indexSet: indexSet, destination: destination)
        })
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
