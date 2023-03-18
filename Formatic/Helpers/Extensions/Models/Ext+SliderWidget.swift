//
//  Ext+SliderWidget.swift
//  Formatic
//
//  Created by Eli Hartnett on 12/3/22.
//

import Foundation

extension SliderWidget: Csv, Copyable {
    
    enum CodingKeys: CodingKey {
        case position
        case title
        case type
        case lowerBound
        case upperBound
        case step
        case number
    }
    
    func toCsv() -> String {
        var csvString = ""
        csvString += FormModel.formatAsCsv(section?.form?.title ?? "") + ","
        csvString += FormModel.formatAsCsv(section?.title ?? "") + ","
        csvString += FormModel.formatAsCsv(title ?? "") + ","
        csvString += Strings.sliderLabel + ","
        csvString += FormModel.formatAsCsv("\(number!) (\(lowerBound!), \(upperBound!))") + ","
        csvString += String(repeating: ",", count: Strings.mapCSVColumns.filter({ character in
            character == ","
        }).count) + ","
        return csvString
    }
    
    func createCopy() -> Any {
        let copy = SliderWidget(title: title, position: Int(position), lowerBound: lowerBound, upperBound: upperBound, step: step, number: number)
        return copy
    }
    
    func reset() {
        self.number = self.lowerBound
    }
}
