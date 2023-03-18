//
//  Labels.swift
//  Formatic
//
//  Created by Eli Hartnett on 11/25/22.
//

import Foundation
import SwiftUI

struct Labels {
    static var copy: some View = Label(Strings.copyLabel, systemImage: Constants.copyIconName).customIcon()
    
    static var reset: some View = Label(Strings.resetLabel, systemImage: Constants.resetIconName).customIcon(foregroundColor: .yellow)

    static var delete: some View = Label(Strings.deleteLabel, systemImage: Constants.trashIconName).customIcon(foregroundColor: .red)

    static let recover: some View = Label(Strings.recoverLabel, systemImage: Constants.plusIconName).customIcon()
    
    static let sort: some View = Label(Strings.sortLabel, systemImage: Constants.sortIconName).customIcon()
    
    static let move: some View = Label(Strings.moveLabel, systemImage: Constants.moveSectionIconName).customIcon()
}
