//
//  ConfigureDropdownSectionWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/3/22.
//

import SwiftUI

// In new widget sheet to configure new DropdownSectionWidget
struct ConfigureDropdownSectionWidgetView: View {
    
    @EnvironmentObject var formModel: FormModel
    @Environment(\.dismiss) var dismiss
    
    @State var dropdownSectionWidget: DropdownSectionWidget?
    @State var localDropdowns: [LocalDropdownWidget] = []
    @Binding var title: String
    @State var section: Section
    @State var numDropdowns: Int = 1
    @State var isValid: Bool = false
    
    var body: some View {
        
        VStack {
            Stepper(value: $numDropdowns, in: 1...10) {
                HStack (spacing: 0) {
                    Text("Number of dropdown options: ")
                    Text("\(numDropdowns)")
                }
            }
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
                if dropdownSectionWidget != nil {
                    let existingArray = (dropdownSectionWidget?.dropdownWidgets as? Set<DropdownWidget> ?? []).sorted { lhs, rhs in
                        lhs.position < rhs.position
                    }
                    for dropownWidget in existingArray {
                        dropdownSectionWidget?.removeFromDropdownWidgets(dropownWidget)
                    }
                    for (index, localDropdown) in localDropdowns.enumerated() {
                        dropdownSectionWidget?.addToDropdownWidgets(DropdownWidget(title: localDropdown.title, position: index))
                    }
                } else {
                    // Create dropdownSectionWidget
                    dropdownSectionWidget = DropdownSectionWidget(title: title, position: formModel.numberOfWidgetsInSection(section: section))
                    
                    // Append dropdown options to dropdownSectionWidget
                    for (index, localDropdown) in localDropdowns.enumerated() {
                        if !localDropdown.title.isEmpty {
                            print("index \(index) added")
                            let dropdownWidget = DropdownWidget(title: localDropdown.title, position: index)
                            dropdownSectionWidget!.addToDropdownWidgets(dropdownWidget)
                        }
                    }
                    
                    // Append dropdownSectionWidget to form section
                    withAnimation {
                        section.addToWidgets(dropdownSectionWidget!)
                    }
                }
                
                withAnimation {
                    DataController.saveMOC()
                }
                
                dismiss()
            } label: {
                SubmitButton(isValid: $isValid)
            }
            .padding(.bottom)
        }
        .frame(maxHeight: .infinity)
        .padding()
        .onAppear {
            // Load existing dropdown
            if let numDropdownSectionWidgetDropdowns = dropdownSectionWidget?.dropdownWidgets?.count {
                numDropdowns = numDropdownSectionWidgetDropdowns
                
                var dropdownsArray: [DropdownWidget] {
                    let set = dropdownSectionWidget?.dropdownWidgets as? Set<DropdownWidget> ?? []
                    return set.sorted { lhs, rhs in
                        lhs.position < rhs.position
                    }
                }
                
                for dropdown in dropdownsArray {
                    localDropdowns.append(LocalDropdownWidget(title: dropdown.title ?? ""))
                }
            }
            else {
                localDropdowns = [LocalDropdownWidget()]
            }
        }
    }
}

struct LocalDropdownWidget: Identifiable, Equatable {
    let id: UUID = UUID()
    var title: String = ""
}

struct ConfigureDropdownSectionWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureDropdownSectionWidgetView(title: .constant(dev.dropdownSectionWidget.title!), section: dev.section)
    }
}
