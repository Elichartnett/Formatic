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
    @State var isValid: Bool = true
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer().frame(maxWidth: .infinity)
                
                Stepper(localDropdowns.count.description, value: $numDropdowns, in: 0...100)
                    .labelsHidden()
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
                
                EditModeButton { }
                
                Spacer().frame(maxWidth: .infinity)
            }
            
            List {
                ForEach($localDropdowns) { $localDropdown in
                    
                    HStack {
                        Button {
                            for index in 0..<localDropdowns.count {
                                if localDropdowns[index].id == localDropdown.id {
                                    localDropdowns[index].selected.toggle()
                                }
                                else {
                                    localDropdowns[index].selected = false
                                }
                            }
                        } label: {
                            Group {
                                if localDropdown.selected {
                                    Image(systemName: Constants.checkmarkIconName)
                                        .customIcon(foregroundColor: .black)
                                }
                                else {
                                    Rectangle().fill(.clear)
                                }
                            }
                            .widgetFrameStyle(width: 40)
                        }
                        .buttonStyle(.plain)
                        
                        InputBox(placeholder: Strings.descriptionLabel, text: $localDropdown.title)
                            .swipeActions {
                                Button {
                                    if let index = localDropdowns.firstIndex(of: localDropdown) {
                                        localDropdowns.remove(at: index)
                                        numDropdowns -= 1
                                    }
                                } label: {
                                    Labels.delete
                                }
                                .tint(.red)
                                
                                Button {
                                    localDropdown.title = Constants.emptyString
                                    localDropdown.selected = false
                                } label: {
                                    Labels.reset
                                }
                                .tint(.yellow)
                                
                                Button {
                                    if let index = localDropdowns.firstIndex(of: localDropdown) {
                                        localDropdowns.insert(LocalDropdownWidget(title: localDropdown.title), at: index + 1)
                                        numDropdowns += 1
                                    }
                                } label: {
                                    Labels.copy
                                }
                                .tint(.blue)
                            }
                    }
                }
                .onMove { indexSet, destination in
                    localDropdowns.move(fromOffsets: indexSet, toOffset: destination)
                }
            }
            .scrollContentBackground(.hidden)
            
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
            numDropdowns = localDropdowns.count
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
                var newLocalDropdown = LocalDropdownWidget(title: dropdown.title ?? Constants.emptyString)
                newLocalDropdown.selected = dropdownSectionWidget?.selectedDropdown?.id == dropdown.id
                localDropdowns.append(newLocalDropdown)
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
            let dropdownWidget = DropdownWidget(title: localDropdown.title, position: index, dropdownSectionWidget: dropdownSectionWidget, selectedDropdownInverse: nil)
            dropdownSectionWidget?.addToDropdownWidgets(dropdownWidget)
            if localDropdown.selected {
                dropdownSectionWidget?.selectedDropdown = dropdownWidget
            }
        }
        if !localDropdowns.contains(where: { localDropdown in
            localDropdown.selected == true
        }) {
            dropdownSectionWidget?.selectedDropdown = nil
        }
    }
    
    func createNewDropdownSectionWidget() {
        let dropdownSectionWidget = DropdownSectionWidget(title: title, position: section.numberOfWidgets(), selectedDropdown: nil, dropdownWidgets: nil)
        
        for (index, localDropdown) in localDropdowns.enumerated() {
            let dropdownWidget = DropdownWidget(title: localDropdown.title, position: index, dropdownSectionWidget: dropdownSectionWidget, selectedDropdownInverse: nil)
            dropdownSectionWidget.addToDropdownWidgets(dropdownWidget)
        }
        
        withAnimation {
            section.addToWidgets(dropdownSectionWidget)
        }
        Analytics.logEvent(Constants.analyticsCreateDropdownWidgetEvent, parameters: nil)
    }
}

struct LocalDropdownWidget: Identifiable, Equatable {
    let id: UUID = UUID()
    var title: String = Constants.emptyString
    var selected: Bool = false
}

struct ConfigureDropdownSectionWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureDropdownSectionWidgetView(title: .constant(dev.dropdownSectionWidget.title!), section: dev.section)
            .environmentObject(FormModel())
    }
}
