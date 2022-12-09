//
//  Labels.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/25/22.
//

import Foundation
import SwiftUI

struct Labels {
    static var copy = Label(Strings.copyLabel, systemImage: Constants.copyIconName)
    
    static var delete = Label(Strings.deleteLabel, systemImage: Constants.trashIconName)
    
    static var export = Label(Strings.exportLabel, systemImage: Constants.exportFormIconName)
    
    static let recover = Label(Strings.recoverLabel, systemImage: Constants.plusIconName)
}
