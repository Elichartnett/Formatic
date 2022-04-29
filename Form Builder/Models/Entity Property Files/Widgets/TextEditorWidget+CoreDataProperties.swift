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
    
}
