//
//  Extensions.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/29/22.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct TitleFrame: ViewModifier {
    @Binding var locked: Bool
    func body(content: Content) -> some View {
        content
            .frame(width: 200)
            .disabled(locked)
    }
}

struct WidgetViewFrame: ViewModifier {
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

extension View {
    func titleFrameStyle(locked: Binding<Bool>) -> some View {
        modifier(TitleFrame(locked: locked))
    }
    
    func WidgetFrameStyle() -> some View {
        modifier(WidgetViewFrame())
    }
}

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

extension UTType {
    static var form: UTType {
        UTType(filenameExtension: "form")!
    }
}
