//
//  SectionView.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/29/22.
//

import SwiftUI
import CoreData

// Displays form sections with section titles and widgets
struct SectionView: View {
    
    @EnvironmentObject var formModel: FormModel
    @FetchRequest var widgets: FetchedResults<Widget>
    
    @ObservedObject var section: Section
    @Binding var locked: Bool
    
    init(section: Section, locked: Binding<Bool>) {
        self._widgets = FetchRequest<Widget>(sortDescriptors: [SortDescriptor(\.position)], predicate: NSPredicate(format: "section == %@", section))
        self.section = section
        self._locked = locked
    }
    
    var body: some View {
        
        // Display all widgets in section
        ForEach(widgets) { widget in
            let widgetType: WidgetType = WidgetType.init(rawValue: widget.type!)!
            
            switch widgetType {
            case .textFieldWidget:
                let textFieldWidget = widget as! TextFieldWidget
                TextFieldWidgetView(textFieldWidget: textFieldWidget, locked: $locked)
                
            case .numberFieldWidget:
                let numberFieldWidget = widget as! NumberFieldWidget
                NumberFieldWidgetView(numberFieldWidget: numberFieldWidget, locked: $locked)
                
            case .textEditorWidget:
                let textEditorWidget = widget as! TextEditorWidget
                TextEditorWidgetView(textEditorWidget: textEditorWidget, locked: $locked)
                
            case .dropdownSectionWidget:
                let dropdownSectionWidget = widget as! DropdownSectionWidget
                DropdownSectionWidgetView(dropdownSectionWidget: dropdownSectionWidget, locked: $locked)
                
            case .dropdownWidget:
                EmptyView()
                
            case .checkboxSectionWidget:
                let checkboxSectionWidget = widget as! CheckboxSectionWidget
                CheckboxSectionWidgetView(checkboxSectionWidget: checkboxSectionWidget, locked: $locked)
                
            case .checkboxWidget:
                EmptyView()
                
            case .mapWidget:
                let mapWidget = widget as! MapWidget
                MapWidgetView(mapWidget: mapWidget, locked: $locked)
                
            case .photoWidget:
                EmptyView()
                
            case .photoLibraryWidget:
                let photoLibraryWidget = widget as! PhotoLibraryWidget
                PhotoLibraryWidgetView(photoLibraryWidget: photoLibraryWidget, locked: $locked)
                
            case .canvasWidget:
                let canvasWidget = widget as! CanvasWidget
                CanvasWidgetView(canvasWidget: canvasWidget, locked: $locked)
            }
        }
        .onMove(perform: { indexSet, destination in
            formModel.moveWidgetWithIndexSet(section: section, indexSet: indexSet, destination: destination)
        })
        .onDelete { indexSet in
            formModel.deleteWidgetWithIndexSet(section: section, indexSet: indexSet)
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
