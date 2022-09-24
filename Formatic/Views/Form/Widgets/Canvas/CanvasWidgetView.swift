//
//  CanvasWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct CanvasWidgetView: View {
    
    @Environment(\.editMode) var editMode
    @ObservedObject var canvasWidget: CanvasWidget
    @Binding var locked: Bool
    @State var title: String
    @State var reconfigureWidget = false
    
    init(canvasWidget: CanvasWidget, locked: Binding<Bool>) {
        self.canvasWidget = canvasWidget
        self._locked = locked
        self._title = State(initialValue: canvasWidget.title ?? "")
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
                ZStack {
                    Image(uiImage: UIImage(data: canvasWidget.image ?? Data()) ?? UIImage())
                        .resizable()
                        .scaledToFit()
                    
                    Image(uiImage: UIImage(data: canvasWidget.widgetViewPreview ?? Data()) ?? UIImage())
                        .resizable()
                        .scaledToFit()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .WidgetPreviewStyle()
            
            Button {
                reconfigureWidget = true
            } label: {
                if editMode?.wrappedValue == .active {
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .foregroundColor(.black)
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                }
            }
            .disabled(editMode?.wrappedValue == .inactive)
            .buttonStyle(.plain)
        }
        .sheet(isPresented: $reconfigureWidget) {
            ConfigureCanvasWidgetView(canvasWidget: canvasWidget, title: $title, section: canvasWidget.section!)
                .padding()
        }
    }
}

struct CanvasWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasWidgetView(canvasWidget: dev.canvasWidget, locked: .constant(false))
    }
}
