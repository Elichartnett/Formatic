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
            
            HStack {
                Spacer().frame(maxWidth: .infinity)
                
                Stepper(localCheckboxes.count.description, value: $numCheckboxes, in: 0...100)
                    .labelsHidden()
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
                
                EditModeButton { }
                
                Spacer().frame(maxWidth: .infinity)
            }
            
            List {
                ForEach($localCheckboxes) { $localCheckbox in
                    
                    HStack {
                        Button {
                            localCheckbox.checked.toggle()
                        } label: {
                            Group {
                                if localCheckbox.checked {
                                    Image(systemName: Constants.filledSquareCheckmarkIconName)
                                        .customIcon(foregroundColor: .secondary)
                                        .accessibilityLabel(Strings.checkedLabel)
                                }
                                else {
                                    Image(systemName: Constants.squareIconName)
                                        .customIcon(foregroundColor: .secondary)
                                        .accessibilityLabel(Strings.uncheckedLabel)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        
                        InputBox(placeholder: Strings.descriptionLabel, text: $localCheckbox.title)
                            .swipeActions {
                                Button {
                                    if let index = localCheckboxes.firstIndex(of: localCheckbox) {
                                        localCheckboxes.remove(at: index)
                                        numCheckboxes -= 1
                                    }
                                } label: {
                                    Labels.delete
                                }
                                .tint(.red)
                                
                                Button {
                                    localCheckbox.title = Constants.emptyString
                                    localCheckbox.checked = false
                                } label: {
                                    Labels.reset
                                }
                                .tint(.yellow)
                                
                                Button {
                                    if let index = localCheckboxes.firstIndex(of: localCheckbox) {
                                        localCheckboxes.insert(LocalCheckboxWidget(title: localCheckbox.title), at: index + 1)
                                        numCheckboxes += 1
                                    }
                                } label: {
                                    Labels.copy
                                }
                                .tint(.blue)
                            }
                    }
                }
                .onMove { indexSet, destination in
                    localCheckboxes.move(fromOffsets: indexSet, toOffset: destination)
                }
            }
            .scrollContentBackground(.hidden)
            
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
                let newLocalCheckbox = LocalCheckboxWidget(title: checkbox.title ?? Constants.emptyString, checked: checkbox.checked)
                localCheckboxes.append(newLocalCheckbox)
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
            checkboxSectionWidget?.addToCheckboxWidgets(CheckboxWidget(title: localCheckbox.title, position: index, checked: localCheckbox.checked, checkboxSectionWidget: checkboxSectionWidget))
        }
    }
    
    func createNewCheckboxSectionWidget() {
        let checkboxSectionWidget = CheckboxSectionWidget(title: title, position: section.numberOfWidgets(), checkboxWidgets: nil)
        
        for (index, localCheckbox) in localCheckboxes.enumerated() {
            let checkboxWidget = CheckboxWidget(title: localCheckbox.title, position: index, checked: localCheckbox.checked, checkboxSectionWidget: nil)
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
    var title = Constants.emptyString
    var checked = false
}

struct ConfigureCheckboxSectionWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureCheckboxSectionWidgetView(title: .constant(dev.checkboxSectionWidget.title!), section: dev.section)
            .environmentObject(FormModel())
    }
}
