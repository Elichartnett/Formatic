//
//  EditModeButton.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/23/22.
//

import SwiftUI

struct EditModeButton: View {
    
    @Environment(\.editMode) var editMode
    @EnvironmentObject var formModel: FormModel
    let onTap: () -> ()
    
    var body: some View {
        
        Button {
            withAnimation {
                if editMode?.wrappedValue == .active {
                    editMode?.wrappedValue = .inactive
                }
                else {
                    editMode?.wrappedValue = .active
                }
                onTap()
            }
        } label: {
            let icon = Image(systemName: Strings.editIconName)
            
            if formModel.isPhone {
                icon
                    .foregroundColor(editMode?.wrappedValue == .active ? .primaryBackground : .blue)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(editMode?.wrappedValue == .active ? .blue : Color.primaryBackground)
                    }
            }
            else {
                HStack {
                    icon
                    if editMode?.wrappedValue == .active {
                        Text(Strings.doneLabel)
                    }
                    else {
                        Text(Strings.editLabel)
                    }
                }
            }
        }
    }
}

struct EditModeButton_Previews: PreviewProvider {
    static var previews: some View {
        EditModeButton(onTap: {})
    }
}
