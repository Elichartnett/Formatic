//
//  DropdownSectionWidgetView.swift
// Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct DropdownSectionWidgetView: View {
    
    @ObservedObject var dropdownWidgetSection: DropdownSectionWidget
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct DropdownSectionWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        DropdownSectionWidgetView(dropdownWidgetSection: dev.dropdownSectionWidget)
    }
}
