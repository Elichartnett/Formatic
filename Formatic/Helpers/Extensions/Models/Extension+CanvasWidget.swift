//
//  Extension+CanvasWidget.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/26/22.
//

import Foundation
import PencilKit

extension CanvasWidget: Csv, Copyable {
    
    enum CodingKeys: CodingKey {
        case position
        case title
        case type
        case image
        case pkDrawing
        case widgetViewPreview
    }
    
    func toCsv() -> String {
        var csvString = ""
        csvString += FormModel.formatAsCsv(section?.form?.title ?? "") + ","
        csvString += FormModel.formatAsCsv(self.section?.title ?? "") + ","
        csvString += FormModel.formatAsCsv(self.title ?? "") + ","
        csvString += Strings.canvasLabel + ","
        csvString += String(repeating: ",", count: Strings.mapCSVColumns.filter({ character in
            character == ","
        }).count) + ","
        return csvString
    }
    
    func createCopy() -> Any {
        let copy = CanvasWidget(title: title, position: Int(position), image: image, pkDrawing: pkDrawing, widgetViewPreview: widgetViewPreview)
        return copy
    }
    
    static func updateWidgetViewPreview(canvasWidget: CanvasWidget, canvasView: PKCanvasView) {
        canvasWidget.pkDrawing = canvasView.drawing.dataRepresentation()
        canvasWidget.widgetViewPreview = canvasView.drawing.image(from: CGRect(origin: .zero, size: canvasView.frame.size), scale: UIScreen.main.scale).pngData()
    }
}
