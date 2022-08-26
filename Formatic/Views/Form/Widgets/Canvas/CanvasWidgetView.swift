//
//  CanvasWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct CanvasWidgetView: View {
    
    @ObservedObject var canvasWidget: CanvasWidget
    @Binding var locked: Bool
    @State var title: String
    
    init(canvasWidget: CanvasWidget, locked: Binding<Bool>) {
        self.canvasWidget = canvasWidget
        self._locked = locked
        self.title = canvasWidget.title ?? ""
    }
    
    var body: some View {
        
        HStack {
            
            InputBox(placeholder: "Title", text: $title)
                .titleFrameStyle(locked: $locked)
                .onChange(of: title) { _ in
                    canvasWidget.title = title
                }
                .disabled(locked)
            
            NavigationLink {
                CanvasWidgetDetailView(canvasWidget: canvasWidget)
            } label: {
                Image(uiImage: UIImage(data: canvasWidget.widgetViewPreview ?? Data()) ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .WidgetPreviewStyle()
        }
    }
}

struct CanvasWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasWidgetView(canvasWidget: dev.canvasWidget, locked: .constant(false))
    }
}
