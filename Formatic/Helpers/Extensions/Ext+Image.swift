//
//  Extension+Image.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/26/22.
//

import Foundation
import SwiftUI

extension Image {
    
    func customIcon(foregroundColor: Color = .blue) -> some View {
        self
            .font(.title2)
            .foregroundColor(foregroundColor)
    }
}
