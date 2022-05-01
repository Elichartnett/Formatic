//
//  Extensions.swift
//  Form Builder
//
//  Created by Eli Hartnett on 4/29/22.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    
    let form: Form
    let section: Section
    let textFieldWidget: TextFieldWidget
    
    private init() {
        form = Form(title: "Form title")
        
        section = Section(title: "Section title")
        form.addToSections(section)
        
        textFieldWidget = TextFieldWidget(title: "Text field title", text: "Text field text")
        section.addToWidgets(textFieldWidget)
    }
}
