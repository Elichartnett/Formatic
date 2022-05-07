//
//  NewDropdownSectionWidgetView.swift
// Formatic
//
//  Created by Eli Hartnett on 5/3/22.
//

import SwiftUI

// In new widget sheet to configure new DropdownSectionWidget
struct NewDropdownSectionWidgetView: View {
    
    @Binding var newWidgetType: WidgetType?
    @Binding var title: String
    @State var section: Section
    @State var numOptions: Int = 1
    @State var localDropdowns: [LocalDropdownWidget] = [LocalDropdownWidget()]
    
    var body: some View {
        
        VStack {
            
            // Scroll wheel picker for selecting number of drop down options
            Picker("Number of boxes", selection: $numOptions) {
                ForEach(1...20, id: \.self) { index in
                    Text(String(index))
                }
            }
            .pickerStyle(.wheel)
            .onChange(of: numOptions) { newVal in
                // Number decreased - remove trailing boxes
                if newVal < localDropdowns.count {
                    withAnimation {
                        localDropdowns.removeSubrange(newVal..<localDropdowns.count)
                    }
                }
                // Number increased - append more boxes
                else {
                    let numToAdd = newVal - localDropdowns.count
                    for _ in 0..<numToAdd {
                        withAnimation {
                            localDropdowns.append(LocalDropdownWidget())
                        }
                    }
                }
            }
            
            ScrollView {
                // Drop down options
                ForEach($localDropdowns) { $localDropdown in
                    InputBox(placeholder: "description", text: $localDropdown.title)
                }
            }
            .padding(.bottom)
            
            Button {
                // Create dropdownSectionWidget
                let dropdownSectionWidget = DropdownSectionWidget(title: title, position: section.widgetsArray.count-1, type: WidgetType.dropdownSectionWidget.rawValue)

                // Append dropdown options to dropdownSectionWidget
                for (index, localDropdown) in localDropdowns.enumerated() {
                    let dropdownWidget = DropdownWidget(title: localDropdown.title, position: index, type: WidgetType.dropdownWidget.rawValue)
                    dropdownSectionWidget.addToDropdowns(dropdownWidget)
                }
                // Append dropdownSectionWidget to form section
                section.addToWidgets(dropdownSectionWidget)
                DataController.saveMOC()
                newWidgetType = nil
            } label: {
                SubmitButton(isValid: .constant(true))
            }
            .padding(.bottom)
        }
        .frame(maxHeight: .infinity)
    }
}

struct LocalDropdownWidget: Identifiable {
    let id: UUID = UUID()
    var title: String = ""
}

struct NewDropdownSectionWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        NewDropdownSectionWidgetView(newWidgetType: .constant(.dropdownSectionWidget), title: .constant(dev.dropdownSectionWidget.title!), section: dev.section)
    }
}
