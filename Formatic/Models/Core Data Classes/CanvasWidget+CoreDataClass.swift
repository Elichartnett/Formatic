//
//  CanvasWidget+CoreDataClass.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/27/22.
//

import Foundation
import CoreData
import PencilKit

@objc(CanvasWidget)
public class CanvasWidget: Widget, Decodable {
    
    init(title: String?, position: Int, image: Data?, pkDrawing: Data?, widgetViewPreview: Data?) {
        super.init(entityName: WidgetType.canvasWidget.rawValue, context: DataControllerModel.shared.container.viewContext, title: title, position: position)
        self.type = WidgetType.canvasWidget.rawValue
        self.image = image
        self.pkDrawing = pkDrawing
        self.widgetViewPreview = widgetViewPreview
    }
    
    required public init(from decoder: Decoder) throws {
        super.init(entityName: WidgetType.canvasWidget.rawValue, context: DataControllerModel.shared.container.viewContext, title: nil, position: 0)
        
        let canvasWidgetContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.position = try canvasWidgetContainer.decode(Int16.self, forKey: .position)
        if let title = try canvasWidgetContainer.decode(String?.self, forKey: .title) {
            self.title = title
        }
        self.type = try canvasWidgetContainer.decode(String.self, forKey: .type)
        
        if let image = try canvasWidgetContainer.decode(Data?.self, forKey: .image) {
            self.image = image
        }
        if let pkDrawing = try canvasWidgetContainer.decode(Data?.self, forKey: .pkDrawing) {
            self.pkDrawing = pkDrawing
        }
        if let widgetViewPreview = try canvasWidgetContainer.decode(Data?.self, forKey: .widgetViewPreview) {
            self.widgetViewPreview = widgetViewPreview
        }
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        
        var canvasWidgetContainer = encoder.container(keyedBy: CodingKeys.self)
        try canvasWidgetContainer.encode(image, forKey: .image)
        try canvasWidgetContainer.encode(pkDrawing, forKey: .pkDrawing)
        try canvasWidgetContainer.encode(widgetViewPreview, forKey: .widgetViewPreview)
    }
}
