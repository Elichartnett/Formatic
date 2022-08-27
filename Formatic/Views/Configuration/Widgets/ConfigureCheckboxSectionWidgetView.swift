//
//  ConfigureCheckboxSectionWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/3/22.
//

import SwiftUI

// In new widget sheet to configure new CheckboxSectionWidget
struct ConfigureCheckboxSectionWidgetView: View {
    
    @EnvironmentObject var formModel: FormModel
    @Environment(\.dismiss) var dismiss

    @Binding var title: String
    @State var section: Section
    @State var numCheckboxes: Int = 1
    @State var localCheckboxes: [LocalCheckboxWidget] = [LocalCheckboxWidget()]
    
    var body: some View {
        
        VStack {
            
            Stepper(value: $numCheckboxes) {
                HStack (spacing: 0) {
                    Text("Number of checkboxes: ")
                    Text("\(numCheckboxes)")
                }
            }
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
                .padding(.horizontal)
                .padding(.top, 1)
            }
            
            Button {
                // Create checkboxSectionWidget
                let checkboxSectionWidget = CheckboxSectionWidget(title: title, position: formModel.numberOfWidgetsInSection(section: section))
                
                // Append checkboxes to checkboxSectionWidget
                for (index, localCheckbox) in localCheckboxes.enumerated() {
                    let checkboxWidget = CheckboxWidget(title: localCheckbox.title, position: index)
                    checkboxSectionWidget.addToCheckboxWidgets(checkboxWidget)
                }
                
                // Append dropdownSectionWidget to form section
                withAnimation {
                    section.addToWidgets(checkboxSectionWidget)
                    DataController.saveMOC()
                }
                dismiss()
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

struct ConfigureCheckboxSectionWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureCheckboxSectionWidgetView(title: .constant(dev.checkboxSectionWidget.title!), section: dev.section)
    }
}
