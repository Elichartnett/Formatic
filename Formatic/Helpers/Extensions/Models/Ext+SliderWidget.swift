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
        var csvString = Constants.emptyString
        csvString += FormModel.formatAsCsv(section?.form?.title ?? Constants.emptyString) + ","
        csvString += FormModel.formatAsCsv(section?.title ?? Constants.emptyString) + ","
        csvString += FormModel.formatAsCsv(title ?? Constants.emptyString) + ","
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
