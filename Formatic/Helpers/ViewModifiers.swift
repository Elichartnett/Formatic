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
            .frame(width: 200)
            .disabled(locked)
    }
}

struct WidgetPreviewFrame: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 200)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.secondary, lineWidth: 2)
            )
            .foregroundColor(.black)
    }
}
