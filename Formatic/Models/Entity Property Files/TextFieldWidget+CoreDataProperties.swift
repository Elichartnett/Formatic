//
//  TextFieldWidget+CoreDataProperties.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import Foundation
import CoreData


extension TextFieldWidget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TextFieldWidget> {
        return NSFetchRequest<TextFieldWidget>(entityName: "TextFieldWidget")
    }

    @NSManaged public var text: String?
}
