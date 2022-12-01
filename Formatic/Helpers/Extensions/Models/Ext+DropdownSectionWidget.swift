//
//  Extension+DropdownSectionWidget.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/26/22.
//

import Foundation

extension DropdownSectionWidget: Csv, Copyable {
    
    enum CodingKeys: CodingKey {
        case position
        case title
        case type
        case selectedDropdown
        case dropdownWidgets
    }
    
    func toCsv() -> String {
        var csvString = ""
        
        if var dropdownWidgets = self.dropdownWidgets?.map( {$0 as! DropdownWidget}) {
            dropdownWidgets = dropdownWidgets.sorted { lhs, rhs in
                lhs.position < rhs.position
            }
            
            for dropdownWidget in dropdownWidgets {
                csvString += FormModel.formatAsCsv(section?.form?.title ?? "") + ","
                csvString += FormModel.formatAsCsv(section?.title ?? "") + ","
                csvString += FormModel.formatAsCsv(title ?? "") + ","
                csvString += Strings.dropdownMenuLabel + ","
                csvString += FormModel.formatAsCsv(dropdownWidget.title ?? "") + ","
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
            
            if csvString != "" {
                csvString.remove(at: csvString.index(before: csvString.endIndex))
            }
        }
        
        return csvString
    }
    
    func createCopy() -> Any {
        let selectedDropdownWidgetCopy = selectedDropdown?.createCopy() as? DropdownWidget
        
        let dropdownWidgetsArray = dropdownWidgets?.allObjects.sorted(by: { lhs, rhs in
            let lhs = lhs as! DropdownWidget
            let rhs = rhs as! DropdownWidget
            return lhs.position < rhs.position
        }) as! [DropdownWidget]
        var dropdownWidgetsCopy = [DropdownWidget]()
        for widget in dropdownWidgetsArray {
            let copy = widget.createCopy() as! DropdownWidget
            dropdownWidgetsCopy.append(copy)
        }
        
        let copy = DropdownSectionWidget(title: title, position: Int(position), selectedDropdown: selectedDropdownWidgetCopy, dropdownWidgets: NSSet(array: dropdownWidgetsCopy))
        return copy
    }
}
