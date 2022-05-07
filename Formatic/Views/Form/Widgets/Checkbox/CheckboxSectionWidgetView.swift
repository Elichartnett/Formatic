//
//  CheckboxSectionWidgetView.swift
// Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct CheckboxSectionWidgetView: View {
    
    @ObservedObject var checkboxSectionWidget: CheckboxSectionWidget
    
    var body: some View {
        
        let rows: [GridItem] = Array(repeating: GridItem(.flexible(minimum: 50, maximum: 100), spacing: nil, alignment: nil), count: 5)
        LazyHGrid(rows: rows) {
            ForEach(checkboxSectionWidget.checkboxesArray, id: \.self) { widget in
                Text("")
            }
        }
    }
}

struct CheckboxSectionWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        CheckboxSectionWidgetView(checkboxSectionWidget: dev.checkboxSectionWidget)
    }
}
