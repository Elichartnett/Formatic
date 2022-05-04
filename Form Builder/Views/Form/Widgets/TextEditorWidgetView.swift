//
//  TextEditorWidgetView.swift
//  Form Builder
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct TextEditorWidgetView: View {
    
    @ObservedObject var textEditorWidget: TextEditorWidget

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct TextEditorWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorWidgetView(textEditorWidget: dev.textEditorWidget)
    }
}
