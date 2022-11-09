//
//  ViewModifiers.swift
//  Formatic
//
//  Created by Eli Hartnett on 9/20/22.
//

import Foundation
import SwiftUI

struct TitleFrame: ViewModifier {
    @Binding var locked: Bool
    func body(content: Content) -> some View {
        content
            .frame(width: 200, height: WidgetViewHeight.regular.rawValue)
            .disabled(locked)
    }
}

struct WidgetFrame: ViewModifier {
    let isFocused: Bool
    let height: WidgetViewHeight

    func body(content: Content) -> some View {
        let border = RoundedRectangle(cornerRadius: 10)
            .stroke(isFocused ? .blue : .secondary, lineWidth: 2)
        
        let view = ZStack {
            content
            border
        }
            .cornerRadius(10)
            .foregroundColor(.primary)
        
        switch height {
        case .regular:
            view
                .frame(height: WidgetViewHeight.regular.rawValue)
        case .adaptive:
            view
                .frame(minHeight: WidgetViewHeight.regular.rawValue, maxHeight: .infinity)
        case .large:
            view
                .frame(height: WidgetViewHeight.large.rawValue)
        }
    }
}
