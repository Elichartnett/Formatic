//
//  Extension+View.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/26/22.
//

import Foundation
import SwiftUI

extension View {
    func titleFrameStyle(locked: Binding<Bool>) -> some View { modifier(TitleFrame(locked: locked)) }
    
    func WidgetFrameStyle(isFocused: Bool = false, height: WidgetViewHeight = .regular) -> some View {
        modifier(WidgetFrame(isFocused: isFocused, height: height))
    }
}
