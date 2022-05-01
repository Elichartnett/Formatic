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
    
    /// TextFieldWidget  convenience init
    convenience init(title: String?, text: String?) {
        self.init(title: title, entity: "TextFieldWidget")
        self.text = text
    }
}
