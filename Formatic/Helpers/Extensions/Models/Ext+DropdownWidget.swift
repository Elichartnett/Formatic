//
//  Extension+DropdownWidget.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/26/22.
//

import Foundation

extension DropdownWidget: Copyable {
    
    enum CodingKeys: String, CodingKey {
        case position
        case title
        case type
    }
    
    func createCopy() -> Any {
        let copy = DropdownWidget(title: title, position: Int(position), dropdownSectionWidget: nil, selectedDropdownInverse: nil)
        return copy
    }
}
