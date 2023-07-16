//
//  Extension+DropdownSectionWidget.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/26/22.
//

import Foundation

extension DropdownSectionWidget: Csv, Copyable {
    
    var dropdownWidgetsArray: [DropdownWidget] {
        let set = dropdownWidgets as? Set<DropdownWidget> ?? []
        return set.sorted { lhs, rhs in
            lhs.position < rhs.position
        }
    }
    
    enum CodingKeys: CodingKey {
        case position
        case title
        case type
        case selectedDropdown
        case dropdownWidgets
    }
    
    func toCsv() -> String {
        var csvString = Constants.emptyString
        
        if var dropdownWidgets = self.dropdownWidgets?.map( {$0 as! DropdownWidget}) {
            dropdownWidgets = dropdownWidgets.sorted { lhs, rhs in
                lhs.position < rhs.position
            }
            
            for dropdownWidget in dropdownWidgets {
                csvString += FormModel.formatAsCsv(section?.form?.title ?? Constants.emptyString) + ","
                csvString += FormModel.formatAsCsv(section?.title ?? Constants.emptyString) + ","
                csvString += FormModel.formatAsCsv(title ?? Constants.emptyString) + ","
                csvString += Strings.dropdownMenuLabel + ","
                csvString += FormModel.formatAsCsv(dropdownWidget.title ?? Constants.emptyString) + ","
                if self.selectedDropdown == dropdownWidget {
                    csvString += "True"
                }
                else {
                    csvString += "False"
                }
                csvString += String(repeating: ",", count: Strings.mapCSVColumns.filter({ character in
                    character == ","
                }).count) + ",\n"
            }
            
            if csvString != Constants.emptyString {
                csvString.remove(at: csvString.index(before: csvString.endIndex))
            }
        }
        
        return csvString
    }
    
    func createCopy() -> Any {
        let selectedDropdownWidgetCopy = selectedDropdown?.createCopy() as? DropdownWidget
        
        var dropdownWidgetsCopy = [DropdownWidget]()
        for widget in dropdownWidgetsArray {
            let copy = widget.createCopy() as! DropdownWidget
            dropdownWidgetsCopy.append(copy)
        }
        
        let copy = DropdownSectionWidget(title: title, position: Int(position), selectedDropdown: selectedDropdownWidgetCopy, dropdownWidgets: NSSet(array: dropdownWidgetsCopy))
        return copy
    }
    
    func reset() {
        self.selectedDropdown = nil
        for widget in dropdownWidgetsArray {
            if widget.selectedDropdownInverse != nil {
                widget.selectedDropdownInverse = nil
            }
        }
    }
}
