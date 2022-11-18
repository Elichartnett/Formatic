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
    
    func WidgetFrameStyle(isFocused: Bool = false, height: WidgetViewHeight = .regular) -> some View {
        modifier(WidgetFrame(isFocused: isFocused, height: height))
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

extension Color {
    static var primaryBackground: Color {
        return Color(CustomColor.primaryBackground.rawValue)
    }
    
    static var secondaryBackground: Color {
        return Color(CustomColor.secondaryBackground.rawValue)
    }
}

extension UIColor {
    static var primaryBackground: UIColor {
        return UIColor(Color.primaryBackground)
    }
    
    static var secondaryBackground: UIColor {
        return UIColor(Color.secondaryBackground)
    }
}

extension Bundle {

    var shortVersion: String {
        if let result = infoDictionary?["CFBundleShortVersionString"] as? String {
            return result
        } else {
            assert(false)
            return ""
        }
    }

    var buildVersion: String {
        if let result = infoDictionary?["CFBundleVersion"] as? String {
            return result
        } else {
            assert(false)
            return ""
        }
    }

    var fullVersion: String {
        return "\(shortVersion) (\(buildVersion))"
    }
}
