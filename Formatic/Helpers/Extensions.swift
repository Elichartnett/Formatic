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
    
    func WidgetPreviewStyle() -> some View {
        modifier(WidgetPreviewFrame())
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
