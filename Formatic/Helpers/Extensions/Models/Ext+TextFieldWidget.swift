//
//  Extension+TextFieldWidget.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/26/22.
//

import Foundation

extension TextFieldWidget: Csv, Copyable {
    
    enum CodingKeys: CodingKey {
        case position
        case title
        case type
        case text
    }
    
    func toCsv() -> String {
        var csvString = ""
        csvString += FormModel.formatAsCsv(section?.form?.title ?? "") + ","
        csvString += FormModel.formatAsCsv(section?.title ?? "") + ","
        csvString += FormModel.formatAsCsv(title ?? "") + ","
        csvString += Strings.textFieldLabel + ","
        csvString += FormModel.formatAsCsv(text ?? "") + ","
        csvString += String(repeating: ",", count: Strings.mapCSVColumns.filter({ character in
            character == ","
        }).count) + ","
        return csvString
    }
    
    func createCopy() -> Any {
        let copy = TextFieldWidget(title: title, position: Int(position), text: text)
        return copy
    }
    
    func reset() {
        self.text = nil
    }
}
