//
//  CanvasWidgetDetailView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/15/22.
//

import SwiftUI
import PencilKit

struct CanvasWidgetDetailView: View {
    
    @ObservedObject var canvasWidget: CanvasWidget
    
    var body: some View {
        CanvasRepresentable(canvasWidget: canvasWidget, size: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - 100)
            .frame(width: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - 100, height: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - 100)
            .border(.black)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(canvasWidget.title ?? "")
    }
}

struct CanvasWidgetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CanvasWidgetDetailView(canvasWidget: dev.canvasWidget)
        }
        .navigationViewStyle(.stack)
    }
}