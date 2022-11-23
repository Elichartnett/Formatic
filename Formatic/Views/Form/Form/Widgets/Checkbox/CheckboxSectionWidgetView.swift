//
//  CheckboxSectionWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct CheckboxSectionWidgetView: View {
    
    @EnvironmentObject var formModel: FormModel
    @FetchRequest var checkboxes: FetchedResults<CheckboxWidget>
    @ObservedObject var checkboxSectionWidget: CheckboxSectionWidget
    @Environment(\.editMode) var editMode
    @State var reconfigureWidget = false
    
    @Binding var locked: Bool
    @State var title: String
    
    init(checkboxSectionWidget: CheckboxSectionWidget, locked: Binding<Bool>) {
        self._checkboxes = FetchRequest<CheckboxWidget>(sortDescriptors: [SortDescriptor(\.position)], predicate: NSPredicate(format: "checkboxSectionWidget == %@", checkboxSectionWidget))
        self.checkboxSectionWidget = checkboxSectionWidget
        self._locked = locked
        self._title = State(initialValue: checkboxSectionWidget.title ?? "")
    }
    
    var body: some View {
        
        let baseView = Group {
            
            let reconfigureButton = Button {
                reconfigureWidget = true
            } label: {
                Image(systemName: Strings.editIconName)
                    .customIcon()
                    .opacity(editMode?.wrappedValue == .active ? 1 : 0)
            }
                .disabled(editMode?.wrappedValue == .inactive)
                .transition(.asymmetric(insertion: .push(from: .trailing), removal: .push(from: .leading)))
            
            Group {
                
                HStack {
                    InputBox(placeholder: Strings.titleLabel, text: $title)
                        .titleFrameStyle(locked: $locked)
                        .padding(.top, formModel.isPhone ? 6 : 0)
                        .onChange(of: title) { _ in
                            checkboxSectionWidget.title = title
                        }
                    
                    if formModel.isPhone {
                        reconfigureButton
                    }
                }
                
                let columns = [GridItem(.adaptive(minimum: 200), alignment: .leading)]
                
                LazyVGrid(columns: columns, alignment: .leading) {
                    ForEach(checkboxes) { checkboxWidget in
                        CheckboxWidgetView(checkbox: checkboxWidget)
                    }
                    .padding(.leading, 5)
                }
                .WidgetFrameStyle(height: .adaptive)
                .padding(.bottom, formModel.isPhone ? 6 : 0)

                if !formModel.isPhone && editMode?.wrappedValue == .active {
                    reconfigureButton
                }
            }
            .sheet(isPresented: $reconfigureWidget) {
                ConfigureCheckboxSectionWidgetView(checkboxSectionWidget: checkboxSectionWidget, title: $title, section: checkboxSectionWidget.section!)
                    .padding()
            }
        }
        
        if formModel.isPhone {
            VStack(alignment: .leading, spacing: FormModel.spacingConstant) {
                baseView
            }
        }
        else {
            HStack(spacing: FormModel.spacingConstant) {
                baseView
            }
        }
    }
}

struct CheckboxSectionWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        CheckboxSectionWidgetView(checkboxSectionWidget: dev.checkboxSectionWidget, locked: .constant(false))
            .environmentObject(FormModel())
    }
}
