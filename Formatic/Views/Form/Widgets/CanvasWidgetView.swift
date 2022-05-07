//
//  CanvasWidgetView.swift
// Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct CanvasWidgetView: View {
    
    @ObservedObject var canvasWidget: CanvasWidget
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CanvasWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasWidgetView(canvasWidget: dev.canvasWidget)
    }
}
