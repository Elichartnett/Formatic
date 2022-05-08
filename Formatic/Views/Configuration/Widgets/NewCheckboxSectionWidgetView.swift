//
//  NewCheckboxSectionWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/3/22.
//

import SwiftUI

// In new widget sheet to configure new CheckboxSectionWidget
struct NewCheckboxSectionWidgetView: View {
    
    @Binding var newWidgetType: WidgetType?
    @Binding var title: String
    @State var section: Section
    @State var numCheckboxes: Int = 1
    @State var localCheckboxes: [LocalCheckboxWidget] = [LocalCheckboxWidget()]
    
    var body: some View {
        
        VStack {
            
            // Scroll wheel picker for selecting number of checkboxes
            Picker("Number of boxes", selection: $numCheckboxes) {
                ForEach(1...20, id: \.self) { index in
                    Text(String(index))
                }
            }
            .pickerStyle(.wheel)
            .onChange(of: numCheckboxes) { newVal in
                withAnimation {
                    // Number decreased - remove trailing boxes
                    if newVal < localCheckboxes.count {
                        localCheckboxes.removeSubrange(newVal..<localCheckboxes.count)
                    }
                    // Number increased - append more boxes
                    else {
                        let numToAdd = newVal - localCheckboxes.count
                        for _ in 0..<numToAdd {
                            localCheckboxes.append(LocalCheckboxWidget())
                        }
                    }
                }
            }
            
            ScrollView {
                // Configure checkboxes
                ForEach($localCheckboxes) { $localCheckbox in
                    InputBox(placeholder: "description", text: $localCheckbox.title)
                }
                .padding()
            }
            
            Button {
                // Create checkboxSectionWidget
                let checkboxSectionWidget = CheckboxSectionWidget(title: title, position: section.widgetsArray.count-1)
                
                // Append checkboxes to checkboxSectionWidget
                for (index, localCheckbox) in localCheckboxes.enumerated() {
                    let checkboxWidget = CheckboxWidget(title: localCheckbox.title, position: index)
                    checkboxSectionWidget.addToCheckboxes(checkboxWidget)
                }
                
                // Append dropdownSectionWidget to form section
                withAnimation {
                    section.addToWidgets(checkboxSectionWidget)
                    DataController.saveMOC()
                }
                newWidgetType = nil
            } label: {
                SubmitButton(isValid: .constant(true))
            }
            .padding(.bottom)
        }
        .frame(maxHeight: .infinity)
    }
}


struct LocalCheckboxWidget: Identifiable, Equatable {
    let id: UUID = UUID()
    var title: String = ""
}

struct NewCheckboxSectionWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        NewCheckboxSectionWidgetView(newWidgetType: .constant(.checkboxSectionWidget), title: .constant(dev.checkboxSectionWidget.title!), section: dev.section)
    }
}
