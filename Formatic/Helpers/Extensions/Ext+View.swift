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
    
    func widgetFrameStyle(isFocused: Bool = false, overrideBorderOn: Bool = false, height: WidgetViewHeight = .regular, width: CGFloat? = nil) -> some View {
        modifier(WidgetFrame(isFocused: isFocused, overrideBorderOn: overrideBorderOn, height: height, width: width))
    }
}
