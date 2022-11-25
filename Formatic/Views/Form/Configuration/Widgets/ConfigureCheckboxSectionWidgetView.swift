//
//  ConfigureCheckboxSectionWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/3/22.
//

import SwiftUI
import FirebaseAnalytics

// In new widget sheet to configure new CheckboxSectionWidget
struct ConfigureCheckboxSectionWidgetView: View {
    
    @EnvironmentObject var formModel: FormModel
    @Environment(\.dismiss) var dismiss
    
    @State var checkboxSectionWidget: CheckboxSectionWidget?
    @Binding var title: String
    @State var section: Section
    @State var numCheckboxes: Int = 1
    @State var localCheckboxes: [LocalCheckboxWidget] = []
    
    var body: some View {
        
        VStack {
            
            Stepper(value: $numCheckboxes) {
                HStack (spacing: 0) {
                    Text(Strings.numberOfCheckboxesLabel)
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
                    InputBox(placeholder: Strings.descriptionLabel, text: $localCheckbox.title)
                }
                .padding(.top, 1)
            }
            
            Button {
                if checkboxSectionWidget != nil {
                    let existingArray = (checkboxSectionWidget?.checkboxWidgets as? Set<CheckboxWidget> ?? []).sorted { lhs, rhs in
                        lhs.position < rhs.position
                    }
                    for checkbox in existingArray {
                        checkboxSectionWidget?.removeFromCheckboxWidgets(checkbox)
                    }
                    for (index, localCheckbox) in localCheckboxes.enumerated() {
                        checkboxSectionWidget?.addToCheckboxWidgets(CheckboxWidget(title: localCheckbox.title, position: index, checked: false, checkboxSectionWidget: checkboxSectionWidget))
                    }
                }
                else {
                    // Create checkboxSectionWidget
                    let checkboxSectionWidget = CheckboxSectionWidget(title: title, position: formModel.numberOfWidgetsInSection(section: section), checkboxWidgets: nil)
                    
                    // Append checkboxes to checkboxSectionWidget
                    for (index, localCheckbox) in localCheckboxes.enumerated() {
                        let checkboxWidget = CheckboxWidget(title: localCheckbox.title, position: index, checked: false, checkboxSectionWidget: nil)
                        checkboxSectionWidget.addToCheckboxWidgets(checkboxWidget)
                    }
                    
                    // Append dropdownSectionWidget to form section
                    withAnimation {
                        section.addToWidgets(checkboxSectionWidget)
                    }
                    Analytics.logEvent(Strings.analyticsCreateCheckboxWidgetEvent, parameters: nil)
                }
                dismiss()
            } label: {
                SubmitButton()
            }
            .padding(.bottom)
        }
        .frame(maxHeight: .infinity)
        .onAppear {
            // Load existing widget
            if let numCheckboxSectionWidgetCheckboxes = checkboxSectionWidget?.checkboxWidgets?.count {
                numCheckboxes = numCheckboxSectionWidgetCheckboxes
                
                var checkboxesArray: [CheckboxWidget] {
                    let set = checkboxSectionWidget?.checkboxWidgets as? Set<CheckboxWidget> ?? []
                    return set.sorted { lhs, rhs in
                        lhs.position < rhs.position
                    }
                }
                
                for checkbox in checkboxesArray {
                    localCheckboxes.append(LocalCheckboxWidget(title: checkbox.title ?? ""))
                }
            }
            else {
                localCheckboxes = [LocalCheckboxWidget()]
            }
        }
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
