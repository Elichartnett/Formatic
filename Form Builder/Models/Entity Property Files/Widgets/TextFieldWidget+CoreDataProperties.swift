//
//  TextFieldWidget+CoreDataProperties.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/27/22.
//
//

import Foundation
import CoreData


extension TextFieldWidget {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TextFieldWidget> {
        return NSFetchRequest<TextFieldWidget>(entityName: "TextFieldWidget")
    }
    
    @NSManaged public var text: String?
    
}
