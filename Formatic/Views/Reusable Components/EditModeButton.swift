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
    
    var disabled = false
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
            let icon = Image(systemName: Constants.editIconName)
                .customIcon(foregroundColor: disabled ? .gray : editMode?.wrappedValue == .active ? .white : .blue)
            
            if formModel.isPhone {
                icon
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(editMode?.wrappedValue == .active ? .blue : Color.clear)
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
        .disabled(disabled)
    }
}

struct EditModeButton_Previews: PreviewProvider {
    static var previews: some View {
        EditModeButton(onTap: {})
            .environmentObject(FormModel())
    }
}
