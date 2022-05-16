//
//  CheckboxSectionWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct CheckboxSectionWidgetView: View {
    
    @ObservedObject var checkboxSectionWidget: CheckboxSectionWidget
    @Binding var locked: Bool
    @State var title: String = ""
    
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
                ForEach(checkboxSectionWidget.checkboxesArray) { checkboxWidget in
                    HStack {
                        CheckboxWidgetView(checkbox: checkboxWidget)
                        Text(checkboxWidget.title ?? "No title")
                    }
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
