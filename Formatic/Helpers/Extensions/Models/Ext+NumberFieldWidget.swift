//
//  Extension+NumberFieldWidget.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/26/22.
//

import Foundation

extension NumberFieldWidget: Csv, Copyable {
    
    enum CodingKeys: CodingKey {
        case position
        case title
        case type
        case number
    }
    
    func toCsv() -> String {
        var csvString = Constants.emptyString
        csvString += FormModel.formatAsCsv(section?.form?.title ?? Constants.emptyString) + ","
        csvString += FormModel.formatAsCsv(section?.title ?? Constants.emptyString) + ","
        csvString += FormModel.formatAsCsv(title ?? Constants.emptyString) + ","
        csvString += Strings.numberFieldLabel + ","
        csvString += FormModel.formatAsCsv(number ?? Constants.emptyString) + ","
        csvString += String(repeating: ",", count: Strings.mapCSVColumns.filter({ character in
            character == ","
        }).count) + ","
        return csvString
    }
    
    func createCopy() -> Any {
        let copy = NumberFieldWidget(title: title, position: Int(position), number: number ?? Constants.emptyString)
        return copy
    }
    
    func reset() {
        self.number = nil
    }
}
