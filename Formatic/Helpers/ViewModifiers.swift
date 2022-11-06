//
//  ViewModifiers.swift
//  Formatic
//
//  Created by Eli Hartnett on 9/20/22.
//

import Foundation
import SwiftUI

let inputHeight: CGFloat = 42
let widgetPreviewHeight: CGFloat = 200

struct TitleFrame: ViewModifier {
    @Binding var locked: Bool
    func body(content: Content) -> some View {
        content
            .frame(width: 200, height: inputHeight)
            .disabled(locked)
    }
}

struct WidgetPreviewFrame: ViewModifier {
    let isFocused: Bool
    
    func body(content: Content) -> some View {
        content
            .frame(height: widgetPreviewHeight)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isFocused ? .blue : .secondary, lineWidth: 2)
            )
            .foregroundColor(.primary)
    }
}

struct WidgetFrame: ViewModifier {
    let isFocused: Bool
    
    func body(content: Content) -> some View {
        content
            .frame(height: inputHeight)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isFocused ? .blue : .secondary, lineWidth: 2)
            )
    }
}
