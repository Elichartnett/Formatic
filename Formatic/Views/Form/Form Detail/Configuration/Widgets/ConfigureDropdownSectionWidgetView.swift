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
    @State var selectedLocalDropdownID: UUID?
    
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
                            if selectedLocalDropdownID == nil {
                                selectedLocalDropdownID = localDropdown.id
                            }
                            else {
                                selectedLocalDropdownID = nil
                                selectedLocalDropdownID = localDropdown.id
                            }
                        } label: {
                            Group {
                                if localDropdown.id == selectedLocalDropdownID {
                                    Image(systemName: Constants.checkmarkIconName)
                                        .customIcon(foregroundColor: .black)
                                }
                                else {
                                    Rectangle().fill(.clear)
                                }
                            }
                            .WidgetFrameStyle(width: 40)
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
                let newLocalDropdown = LocalDropdownWidget(title: dropdown.title ?? "")
                localDropdowns.append(newLocalDropdown)
                if dropdownSectionWidget?.selectedDropdown?.id == dropdown.id {
                    selectedLocalDropdownID = newLocalDropdown.id
                }
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
            if localDropdown.id == selectedLocalDropdownID {
                dropdownSectionWidget?.selectedDropdown = dropdownWidget
            }
        }
    }
    
    func createNewDropdownSectionWidget() {
        let dropdownSectionWidget = DropdownSectionWidget(title: title, position: section.numberOfWidgets(), selectedDropdown: nil, dropdownWidgets: nil)
        
        for (index, localDropdown) in localDropdowns.enumerated() {
            let dropdownWidget = DropdownWidget(title: localDropdown.title, position: index, dropdownSectionWidget: dropdownSectionWidget, selectedDropdownInverse: nil)
            if localDropdown.id == selectedLocalDropdownID {
                dropdownSectionWidget.selectedDropdown = dropdownWidget
            }
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
    var title: String = ""
}

struct ConfigureDropdownSectionWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureDropdownSectionWidgetView(title: .constant(dev.dropdownSectionWidget.title!), section: dev.section)
            .environmentObject(FormModel())
    }
}
