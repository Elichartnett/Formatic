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
    @State var showAlert: Bool = false
    @State var alertTitle: String = ""
    @State var alertButtonDismissMessage: String = Strings.defaultAlertButtonDismissMessage
    let width = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - 100
    
    var body: some View {
        CanvasRepresentable(canvasWidget: canvasWidget, showAlert: $showAlert, alertTitle: $alertTitle, width: width)
            .frame(width: width, height: width)
            .border(.black)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(canvasWidget.title ?? "")
            .alert(alertTitle, isPresented: $showAlert, actions: {
                Button(alertButtonDismissMessage, role: .cancel) {}
            })
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
