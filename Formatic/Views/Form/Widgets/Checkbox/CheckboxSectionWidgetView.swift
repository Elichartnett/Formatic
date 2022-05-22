//
//  CheckboxSectionWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct CheckboxSectionWidgetView: View {
    
    @FetchRequest var checkboxes: FetchedResults<CheckboxWidget>
    @ObservedObject var checkboxSectionWidget: CheckboxSectionWidget
    
    @Binding var locked: Bool
    @State var title: String = ""
    
    init(checkboxSectionWidget: CheckboxSectionWidget, locked: Binding<Bool>) {
        self._checkboxes = FetchRequest<CheckboxWidget>(sortDescriptors: [SortDescriptor(\.position)], predicate: NSPredicate(format: "checkboxSectionWidget == %@", checkboxSectionWidget))
        self.checkboxSectionWidget = checkboxSectionWidget
        self._locked = locked
    }
    
    var body: some View {
        HStack {
            
            InputBox(placeholder: "Title", text: $title)
                .titleFrameStyle(locked: $locked)
                .onChange(of: title) { _ in
                    checkboxSectionWidget.title = title
                }
                .onAppear {
                    title = checkboxSectionWidget.title ?? ""
                }
            
            let columns: [GridItem] = Array(repeating: GridItem(.flexible(minimum: 100, maximum: 150), spacing: 20, alignment: nil), count: 3)
            LazyVGrid(columns: columns, alignment: .leading) {
                ForEach(checkboxes) { checkboxWidget in
                    CheckboxWidgetView(checkbox: checkboxWidget)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct CheckboxSectionWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        CheckboxSectionWidgetView(checkboxSectionWidget: dev.checkboxSectionWidget, locked: .constant(false))
    }
}
