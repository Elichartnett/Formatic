//
//  CanvasWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct CanvasWidgetView: View {
    
    @ObservedObject var canvasWidget: CanvasWidget
    @State var title: String = ""
    @Binding var locked: Bool
    
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
                ZStack {
                    Image(uiImage: UIImage(data: canvasWidget.image ?? Data()) ?? UIImage())
                        .resizable()
                        .scaledToFit()
                    
                    Image(uiImage: UIImage(data: canvasWidget.preview ?? Data()) ?? UIImage())
                        .resizable()
                }
                .DetailFrameStyle()
            }
        }
        .onAppear {
            title = canvasWidget.title ?? ""
        }
    }
}

struct CanvasWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasWidgetView(canvasWidget: dev.canvasWidget, title: dev.canvasWidget.title!, locked: .constant(false))
    }
}
