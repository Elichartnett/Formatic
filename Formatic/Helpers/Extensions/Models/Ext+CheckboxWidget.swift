//
//  Extension+CheckboxWidget.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/26/22.
//

import Foundation

extension CheckboxWidget: Copyable {
    
    enum CodingKeys: CodingKey {
        case position
        case title
        case type
        case checked
    }
    
    func createCopy() -> Any {
        let copy = CheckboxWidget(title: title, position: Int(position), checked: checked, checkboxSectionWidget: nil)
        return copy
    }
}
