//
//  FormModel.swift
//  Formatic
//
//  Created by Eli Hartnett on 4/28/22.
//

import Foundation
import SwiftUI
import CoreData
import MapKit
import PencilKit
import FirebaseAnalytics

class FormModel: ObservableObject {
    
    @Published var navigationPath = NavigationPath()
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var isPhone = UIDevice.current.userInterfaceIdiom == .phone
    
    static func formatAsCsv(_ string: String) -> String {
        var csvString = ""
        
        // In case user *specifcally* used normal quotes in their text
        if string.contains("\""){
            csvString = string.replacingOccurrences(of: "\"", with: "“")
        }
        else {
            csvString = string
        }
        
        // Add single quotes in case of commas present in text
        if csvString.contains(",") || string.contains("\n") {
            csvString = "\"" + csvString + "\""
        }
        
        return csvString
    }
    
    static func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    static func getDeviceInformation() -> String {
        let device = UIDevice.current.name
        let deviceVersion = UIDevice.current.systemVersion
        return
                        """
                        -----------------------------
                        Device: \(device)
                        Device Version: \(deviceVersion)
                        Formatic Version: \(Bundle.main.fullVersion)
                        -----------------------------
                        \n
                        """
    }
}
