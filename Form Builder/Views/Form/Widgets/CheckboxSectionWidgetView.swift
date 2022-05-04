//
//  CheckboxSectionWidgetView.swift
//  Form Builder
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct CheckboxSectionWidgetView: View {
    
    @ObservedObject var checkboxSectionWidget: CheckboxSectionWidget
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CheckboxSectionWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        CheckboxSectionWidgetView(checkboxSectionWidget: dev.checkboxSectionWidget)
    }
}
