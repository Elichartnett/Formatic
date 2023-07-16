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
        var csvString = Constants.emptyString
        csvString += FormModel.formatAsCsv(section?.form?.title ?? Constants.emptyString) + ","
        csvString += FormModel.formatAsCsv(section?.title ?? Constants.emptyString) + ","
        csvString += FormModel.formatAsCsv(title ?? Constants.emptyString) + ","
        csvString += Strings.textFieldLabel + ","
        csvString += FormModel.formatAsCsv(text ?? Constants.emptyString) + ","
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
