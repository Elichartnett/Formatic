//
//  CanvasWidgetDetailView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/15/22.
//

import SwiftUI

struct CanvasWidgetDetailView: View {
    
    @ObservedObject var canvasWidget: CanvasWidget
    @State var showAlert: Bool = false
    @State var alertTitle: String = Constants.emptyString
    let width = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - 100
    
    var body: some View {
        CanvasRepresentable(canvasWidget: canvasWidget, showAlert: $showAlert, alertTitle: $alertTitle, width: width)
            .frame(width: width, height: width)
            .border(.secondary)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(canvasWidget.title ?? Constants.emptyString)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.primaryBackground).ignoresSafeArea()
            .alert(alertTitle, isPresented: $showAlert, actions: {
                Button(Strings.defaultAlertButtonDismissMessage, role: .cancel) {}
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
