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

    static let recover = Label(Strings.recoverLabel, systemImage: Constants.plusIconName)
    
    static let sort = Label(Strings.sortLabel, systemImage: Constants.sortIconName)
    
    static let move = Label(Strings.moveLabel, systemImage: Constants.moveIconName)
}
