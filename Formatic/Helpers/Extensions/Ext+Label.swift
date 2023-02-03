//
//  Ext+Label.swift
//  Formatic
//
//  Created by Eli Hartnett on 2/2/23.
//

import Foundation
import SwiftUI

extension Label {
    
    func customIcon(foregroundColor: Color = .blue) -> some View {
        self
            .font(.title2)
            .foregroundColor(foregroundColor)
    }
}
