//
//  Ext+DateFieldWidget.swift
//  Formatic
//
//  Created by Eli Hartnett on 12/3/22.
//

import Foundation

extension DateFieldWidget: Csv, Copyable {
    
    enum CodingKeys: CodingKey {
        case position
        case title
        case type
        case date
    }
    
    func toCsv() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .long
        var csvString = ""
        csvString += FormModel.formatAsCsv(section?.form?.title ?? "") + ","
        csvString += FormModel.formatAsCsv(section?.title ?? "") + ","
        csvString += FormModel.formatAsCsv(title ?? "") + ","
        csvString += Strings.dateFieldLabel + ","
        csvString += FormModel.formatAsCsv(dateFormatter.string(from: date!)) + ","
        csvString += String(repeating: ",", count: Strings.mapCSVColumns.filter({ character in
            character == ","
        }).count) + ","
        return csvString
    }
    
    func createCopy() -> Any {
        let copy = DateFieldWidget(title: title, position: Int(position), date: date)
        return copy
    }
    
    func reset() {
        self.date = Date()
    }
}
