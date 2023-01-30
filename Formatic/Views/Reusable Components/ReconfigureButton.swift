//
//  ReconfigureButton.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/30/22.
//

import SwiftUI

struct ReconfigureWidgetButton: View {
    
    @Environment(\.editMode) var editMode
    
    @Binding var reconfigureWidget: Bool
    
    var body: some View {
        
        Button {
            reconfigureWidget = true
        } label: {
            Image(systemName: Constants.editIconName)
                .customIcon()
                .opacity(editMode?.wrappedValue == .active ? 1 : 0)
        }
        .disabled(editMode?.wrappedValue == .inactive)
        .buttonStyle(.plain)
        .accessibilityHidden(editMode?.wrappedValue == .inactive)
    }
}

struct ReconfigureButton_Previews: PreviewProvider {
    static var previews: some View {
        ReconfigureWidgetButton(reconfigureWidget: .constant(true))
    }
}
