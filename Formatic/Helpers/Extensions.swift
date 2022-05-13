//
//  Extensions.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/29/22.
//

import Foundation
import SwiftUI

struct TitleFrame: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 200)
    }
}

extension View {
    func titleFrameStyle() -> some View {
        modifier(TitleFrame())
    }
}

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}
