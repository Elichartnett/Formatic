//
//  ConfigureDropdownSectionWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/3/22.
//
import SwiftUI
import FirebaseAnalytics

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
            Stepper(value: $numDropdowns, in: 1...100) {
                HStack (spacing: 0) {
                    Text(Strings.numberOfDropdownOptionsLabel)
                    Text(numDropdowns.description)
                }
            }
            .onChange(of: numDropdowns) { newVal in
                withAnimation {
                    if newVal < localDropdowns.count {
                        localDropdowns.removeSubrange(newVal..<localDropdowns.count)
                    }
                    else {
                        let numToAdd = newVal - localDropdowns.count
                        for _ in 0..<numToAdd {
                            localDropdowns.append(LocalDropdownWidget())
                        }
                    }
                }
            }
            
            ScrollView {
                ForEach($localDropdowns) { $localDropdown in
                    InputBox(placeholder: Strings.descriptionLabel, text: $localDropdown.title)
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
                    updateExistingDropdownSectionWidget()
                } else {
                    createNewDropdownSectionWidget()
                }
                dismiss()
            } label: {
                SubmitButton()
            }
            .disabled(!isValid)
            .padding(.bottom)
        }
        .frame(maxHeight: .infinity)
        .onAppear {
            loadDropdownSectionWidget()
        }
    }
    
    func loadDropdownSectionWidget() {
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
    func updateExistingDropdownSectionWidget() {
        let existingArray = (dropdownSectionWidget?.dropdownWidgets as? Set<DropdownWidget> ?? []).sorted { lhs, rhs in
            lhs.position < rhs.position
        }
        for dropownWidget in existingArray {
            dropdownSectionWidget?.removeFromDropdownWidgets(dropownWidget)
        }
        for (index, localDropdown) in localDropdowns.enumerated() {
            dropdownSectionWidget?.addToDropdownWidgets(DropdownWidget(title: localDropdown.title, position: index, dropdownSectionWidget: dropdownSectionWidget, selectedDropdownInverse: nil))
        }
    }
    
    func createNewDropdownSectionWidget() {
        let dropdownSectionWidget = DropdownSectionWidget(title: title, position: section.numberOfWidgets(), selectedDropdown: nil, dropdownWidgets: nil)
        
        for (index, localDropdown) in localDropdowns.enumerated() {
            if !localDropdown.title.isEmpty {
                let dropdownWidget = DropdownWidget(title: localDropdown.title, position: index, dropdownSectionWidget: dropdownSectionWidget, selectedDropdownInverse: nil)
                dropdownSectionWidget.addToDropdownWidgets(dropdownWidget)
            }
        }
        
        withAnimation {
            section.addToWidgets(dropdownSectionWidget)
        }
        Analytics.logEvent(Constants.analyticsCreateDropdownWidgetEvent, parameters: nil)
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
