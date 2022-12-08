//
//  ConfigureCheckboxSectionWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/3/22.
//
import SwiftUI
import FirebaseAnalytics

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
                    if newVal < localCheckboxes.count {
                        localCheckboxes.removeSubrange(newVal..<localCheckboxes.count)
                    }
                    else {
                        let numToAdd = newVal - localCheckboxes.count
                        for _ in 0..<numToAdd {
                            localCheckboxes.append(LocalCheckboxWidget())
                        }
                    }
                }
            }
            
            ScrollView {
                ForEach($localCheckboxes) { $localCheckbox in
                    InputBox(placeholder: Strings.descriptionLabel, text: $localCheckbox.title)
                }
            }
            
            Button {
                if checkboxSectionWidget != nil {
                    updateExistingCheckboxSectionWidget()
                }
                else {
                    createNewCheckboxSectionWidget()
                }
                dismiss()
            } label: {
                SubmitButton()
            }
            .padding(.bottom)
        }
        .frame(maxHeight: .infinity)
        .onAppear {
           loadCheckboxSectionWidget()
        }
    }
    
    func loadCheckboxSectionWidget() {
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
    
    func updateExistingCheckboxSectionWidget() {
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
    
    func createNewCheckboxSectionWidget() {
        let checkboxSectionWidget = CheckboxSectionWidget(title: title, position: section.numberOfWidgets(), checkboxWidgets: nil)
        
        for (index, localCheckbox) in localCheckboxes.enumerated() {
            let checkboxWidget = CheckboxWidget(title: localCheckbox.title, position: index, checked: false, checkboxSectionWidget: nil)
            checkboxSectionWidget.addToCheckboxWidgets(checkboxWidget)
        }
        
        withAnimation {
            section.addToWidgets(checkboxSectionWidget)
        }
        Analytics.logEvent(Constants.analyticsCreateCheckboxWidgetEvent, parameters: nil)
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
