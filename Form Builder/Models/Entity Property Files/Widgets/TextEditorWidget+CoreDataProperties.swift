//
//  TextEditorWidget+CoreDataProperties.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/27/22.
//
//

import Foundation
import CoreData


extension TextEditorWidget {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TextEditorWidget> {
        return NSFetchRequest<TextEditorWidget>(entityName: "TextEditorWidget")
    }
    
    @NSManaged public var text: String?
    
    /// TextEditorWidget  convenience init
    convenience init(title: String?, position: Int, text: String?) {
        self.init(title: title, position: position, type: WidgetType.textEditorWidget.rawValue)
        self.text = text
    }
}
