//
//  Extension+CheckboxSectionWidget.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/26/22.
//

import Foundation

extension CheckboxSectionWidget: Csv, Copyable {
    
    var sortedCheckboxArray: [CheckboxWidget] {
        let set = checkboxWidgets as? Set<CheckboxWidget> ?? []
        return set.sorted { lhs, rhs in
            lhs.position < rhs.position
        }
    }
    
    enum CodingKeys: CodingKey {
        case position
        case title
        case type
        case checkboxWidgets
    }
    
    func toCsv() -> String {
        var csvString = ""
        
        if var checkboxWidgets = self.checkboxWidgets?.map( {$0 as! CheckboxWidget}) {
            checkboxWidgets = checkboxWidgets.sorted { lhs, rhs in
                lhs.position < rhs.position
            }
            
            for checkboxWidget in checkboxWidgets {
                csvString += FormModel.formatAsCsv(section?.form?.title ?? "") + ","
                csvString += FormModel.formatAsCsv(section?.title ?? "") + ","
                csvString += FormModel.formatAsCsv(title ?? "") + ","
                csvString += Strings.checkboxMenuLabel + ","
                csvString += FormModel.formatAsCsv(checkboxWidget.title ?? "") + ","
                if checkboxWidget.checked == true {
                    csvString += Strings.trueLabel
                }
                else {
                    csvString += Strings.falseLabel
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
        let checkboxWidgetsArray = checkboxWidgets?.allObjects.sorted(by: { lhs, rhs in
            let lhs = lhs as! CheckboxWidget
            let rhs = rhs as! CheckboxWidget
            return lhs.position < rhs.position
        }) as! [CheckboxWidget]
        var checkboxWidgetsCopy = [CheckboxWidget]()
        for widget in checkboxWidgetsArray {
            let copy = widget.createCopy() as! CheckboxWidget
            checkboxWidgetsCopy.append(copy)
        }
        
        let copy = CheckboxSectionWidget(title: title, position: Int(position), checkboxWidgets: NSSet(array: checkboxWidgetsCopy))
        return copy
    }
    
    func reset() {
        for checkbox in self.sortedCheckboxArray {
            checkbox.checked = false
        }
    }
}
