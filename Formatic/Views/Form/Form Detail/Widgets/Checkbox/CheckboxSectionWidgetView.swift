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
    @Environment(\.editMode) var editMode
    
    @ObservedObject var checkboxSectionWidget: CheckboxSectionWidget
    @State var reconfigureWidget = false
    @Binding var locked: Bool
    @State var title: String
    
    init(checkboxSectionWidget: CheckboxSectionWidget, locked: Binding<Bool>) {
        self._checkboxes = FetchRequest<CheckboxWidget>(sortDescriptors: [SortDescriptor(\.position)], predicate: NSPredicate(format: Constants.predicateCheckboxSectionWidgetEqualTo, checkboxSectionWidget))
        self.checkboxSectionWidget = checkboxSectionWidget
        self._locked = locked
        self._title = State(initialValue: checkboxSectionWidget.title ?? "")
    }
    
    var body: some View {
        
        let baseView = Group {
            
            Group {
                
                HStack {
                    InputBox(placeholder: Strings.titleLabel, text: $title)
                        .titleFrameStyle(locked: $locked)
                        .onChange(of: title) { _ in
                            checkboxSectionWidget.title = title
                        }
                    
                    if formModel.isPhone {
                        ReconfigureWidgetButton(reconfigureWidget: $reconfigureWidget)
                    }
                }
                
                let columns = [GridItem(.adaptive(minimum: 200), alignment: .leading)]
                
                LazyVGrid(columns: columns, alignment: .leading) {
                    ForEach(checkboxes) { checkboxWidget in
                        CheckboxWidgetView(checkbox: checkboxWidget)
                    }
                    .padding(.leading)
                }
                .widgetFrameStyle(height: .adaptive)
                
                if !formModel.isPhone && editMode?.wrappedValue == .active {
                    ReconfigureWidgetButton(reconfigureWidget: $reconfigureWidget)
                }
            }
            .sheet(isPresented: $reconfigureWidget) {
                ConfigureCheckboxSectionWidgetView(checkboxSectionWidget: checkboxSectionWidget, title: $title, section: checkboxSectionWidget.section!)
                    .padding()
            }
        }
        
        if formModel.isPhone {
            VStack(alignment: .leading, spacing: Constants.stackSpacingConstant) {
                baseView
            }
        }
        else {
            HStack(spacing: Constants.stackSpacingConstant) {
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
