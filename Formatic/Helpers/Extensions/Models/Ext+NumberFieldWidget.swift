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
        var csvString = ""
        csvString += FormModel.formatAsCsv(section?.form?.title ?? "") + ","
        csvString += FormModel.formatAsCsv(section?.title ?? "") + ","
        csvString += FormModel.formatAsCsv(title ?? "") + ","
        csvString += Strings.numberFieldLabel + ","
        csvString += FormModel.formatAsCsv(number ?? "") + ","
        csvString += String(repeating: ",", count: Strings.mapCSVColumns.filter({ character in
            character == ","
        }).count) + ","
        return csvString
    }
    
    func createCopy() -> Any {
        let copy = NumberFieldWidget(title: title, position: Int(position), number: number ?? "")
        return copy
    }
    
    func reset() {
        self.number = nil
    }
}
