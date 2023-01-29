//
//  SliderWidget+CoreDataClass.swift
//  Formatic
//
//  Created by Eli Hartnett on 12/3/22.
//
//

import Foundation
import CoreData

@objc(SliderWidget)
public class SliderWidget: Widget, Decodable {

    init(title: String?, position: Int, lowerBound: String?, upperBound: String?, step: String?, number: String?) {
        super.init(entityName: WidgetType.sliderWidget.rawValue, context: DataControllerModel.shared.container.viewContext, title: title, position: position)
        self.type = WidgetType.sliderWidget.rawValue
        self.lowerBound = lowerBound
        self.upperBound = upperBound
        self.step = step
        self.number = number
    }
    
    required public init(from decoder: Decoder) throws {
        super.init(entityName: WidgetType.sliderWidget.rawValue, context: DataControllerModel.shared.container.viewContext, title: nil, position: 0)
        
        let sliderWidgetContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.position = try sliderWidgetContainer.decode(Int16.self, forKey: .position)
        if let title = try sliderWidgetContainer.decode(String?.self, forKey: .title) {
            self.title = title
        }
        self.type = try sliderWidgetContainer.decode(String.self, forKey: .type)
        if let lowerBound = try sliderWidgetContainer.decode(String?.self, forKey: .lowerBound) {
            self.lowerBound = lowerBound
        }
        if let upperBound = try sliderWidgetContainer.decode(String?.self, forKey: .upperBound) {
            self.upperBound = upperBound
        }
        if let step = try sliderWidgetContainer.decode(String?.self, forKey: .step) {
            self.step = step
        }
        if let number = try sliderWidgetContainer.decode(String?.self, forKey: .number) {
            self.number = number
        }
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        
        var sliderWidgetContainer = encoder.container(keyedBy: CodingKeys.self)
        try sliderWidgetContainer.encode(lowerBound, forKey: .lowerBound)
        try sliderWidgetContainer.encode(upperBound, forKey: .upperBound)
        try sliderWidgetContainer.encode(step, forKey: .step)
        try sliderWidgetContainer.encode(number, forKey: .number)
    }
}
