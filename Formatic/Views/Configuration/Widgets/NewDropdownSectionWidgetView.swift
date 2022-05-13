//
//  NewDropdownSectionWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/3/22.
//

import SwiftUI

// In new widget sheet to configure new DropdownSectionWidget
struct NewDropdownSectionWidgetView: View {
    
    @Binding var newWidgetType: WidgetType?
    @Binding var title: String
    @State var section: Section
    @State var numDropdowns: Int = 1
    @State var localDropdowns: [LocalDropdownWidget] = [LocalDropdownWidget()]
    @State var isValid: Bool = false
    
    var body: some View {
        
        VStack {
            
            // Scroll wheel picker for selecting number of drop down options
            Picker("Number of boxes", selection: $numDropdowns) {
                ForEach(1...20, id: \.self) { index in
                    Text(String(index))
                }
            }
            .pickerStyle(.wheel)
            .onChange(of: numDropdowns) { newVal in
                withAnimation {
                    // Number decreased - remove trailing boxes
                    if newVal < localDropdowns.count {
                        localDropdowns.removeSubrange(newVal..<localDropdowns.count)
                    }
                    // Number increased - append more boxes
                    else {
                        let numToAdd = newVal - localDropdowns.count
                        for _ in 0..<numToAdd {
                            localDropdowns.append(LocalDropdownWidget())
                        }
                    }
                }
            }
            
            ScrollView {
                // Configure drop down options
                ForEach($localDropdowns) { $localDropdown in
                    InputBox(placeholder: "description", text: $localDropdown.title)
                }
                .padding()
                .onChange(of: localDropdowns) { _ in
                    withAnimation {
                        if localDropdowns.contains(where: { localDropdown in
                            localDropdown.title.isEmpty
                        }) {
                            isValid = false
                        }
                        else {
                            isValid = true
                        }
                    }
                }
            }
            
            Button {
                // Create dropdownSectionWidget
                let dropdownSectionWidget = DropdownSectionWidget(title: title, position: section.widgetsArray.count)
                
                // Append dropdown options to dropdownSectionWidget
                for (index, localDropdown) in localDropdowns.enumerated() {
                    if !localDropdown.title.isEmpty {
                        let dropdownWidget = DropdownWidget(title: localDropdown.title, position: index)
                        dropdownSectionWidget.addToDropdowns(dropdownWidget)
                    }
                }
                
                // Append dropdownSectionWidget to form section
                withAnimation {
                    section.addToWidgets(dropdownSectionWidget)
                    DataController.saveMOC()
                }
                newWidgetType = nil
            } label: {
                SubmitButton(isValid: $isValid)
            }
            .padding(.bottom)
        }
        .frame(maxHeight: .infinity)
    }
}

struct LocalDropdownWidget: Identifiable, Equatable {
    let id: UUID = UUID()
    var title: String = ""
}

struct NewDropdownSectionWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        NewDropdownSectionWidgetView(newWidgetType: .constant(.dropdownSectionWidget), title: .constant(dev.dropdownSectionWidget.title!), section: dev.section)
    }
}
