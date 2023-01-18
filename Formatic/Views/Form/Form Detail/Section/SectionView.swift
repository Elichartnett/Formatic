//
//  SectionView.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/29/22.
//

import SwiftUI

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
        self._widgets = FetchRequest<Widget>(sortDescriptors: [SortDescriptor(\.position)], predicate: NSPredicate(format: Constants.predicateSectionEqualTo, section))
        self.section = section
        self._locked = locked
        self.forPDF = forPDF
    }
    
    var body: some View {
        
        if widgets.isEmpty {
            // Empty view representing section - used as work around for vertical spacing issue when adding multiple sections at once without any widgets in the section
            Color.secondaryBackground
                .frame(height: 45)
                .listRowBackground(Color.secondaryBackground)
        }
        else {
            // Must identify with self for list selection
            ForEach(widgets, id: \.self) { widget in
                VStack(spacing: 0) {
                    WidgetView(widget: widget, locked: $locked, forPDF: forPDF)
                    
                    if forPDF && widget != widgets[widgets.count - 1] {
                        Divider()
                            .padding(.vertical, 10)
                    }
                }
            }
            .onMove(perform: { indexSet, destination in
                section.updateWidgetPositions(indexSet: indexSet, destination: destination)
            })
            .moveDisabled(moveDisabled)
            .listRowBackground(Color.secondaryBackground)
            .onChange(of: section.widgets?.hashValue) { _ in
                resolvePositions()
            }
        }
    }
    
    func resolvePositions() {
        for (index, widget) in section.sortedWidgetsArray().enumerated() {
            widget.position = Int16(index)
        }
        try? DataControllerModel.saveMOC()
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
