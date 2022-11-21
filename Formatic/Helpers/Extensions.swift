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
    func titleFrameStyle(locked: Binding<Bool>) -> some View { modifier(TitleFrame(locked: locked)) }
    
    func WidgetFrameStyle(isFocused: Bool = false, height: WidgetViewHeight = .regular) -> some View {
        modifier(WidgetFrame(isFocused: isFocused, height: height))
    }
}

extension PreviewProvider {
    static var dev: DeveloperPreview { DeveloperPreview.instance }
}

extension UTType {
    static var form: UTType {
        UTType(filenameExtension: "form")!
    }
}

extension Image { 
    func customIcon() -> some View { self.foregroundColor(.blue) }
}

extension Color {
    static var primaryBackground: Color { Color(CustomColor.primaryBackground.rawValue) }
    
    static var secondaryBackground: Color { Color(CustomColor.secondaryBackground.rawValue) }
    
    static var customGray: Color { Color(CustomColor.customGray.rawValue) }
}

extension UIColor {
    static var primaryBackground: UIColor { UIColor(Color.primaryBackground) }
    
    static var secondaryBackground: UIColor { UIColor(Color.secondaryBackground) }
    
    static var customGray: UIColor { UIColor(Color.customGray) }
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
    
    var fullVersion: String { "\(shortVersion) (\(buildVersion))" }
}

extension UTType: Identifiable {
    public var id: UUID {
        return UUID()
    }
}
