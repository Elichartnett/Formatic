//
//  Extensions.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/29/22.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

extension View {
    func titleFrameStyle(locked: Binding<Bool>) -> some View {
        modifier(TitleFrame(locked: locked))
    }
    
    func WidgetFrameStyle(isFocused: Bool = false) -> some View {
        modifier(WidgetFrame(isFocused: isFocused))
    }
    
    func WidgetPreviewStyle(isFocused: Bool = false) -> some View {
        modifier(WidgetPreviewFrame(isFocused: isFocused))
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

extension Image {
    func customIcon() -> some View {
        return self
            .resizable()
            .foregroundColor(.gray)
            .scaledToFit()
            .frame(width: 25, height: 25)
    }
}
