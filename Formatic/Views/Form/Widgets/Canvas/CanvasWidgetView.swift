//
//  CanvasWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI
import PencilKit

struct CanvasWidgetView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.editMode) var editMode
    @ObservedObject var canvasWidget: CanvasWidget
    @Binding var locked: Bool
    @State var title: String
    @State var reconfigureWidget = false
    let width = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - 100
    @State var showAlert: Bool = false
    @State var alertTitle: String = ""
    @State var alertButtonDismissMessage: String = Strings.defaultAlertButtonDismissMessage
    
    init(canvasWidget: CanvasWidget, locked: Binding<Bool>) {
        self.canvasWidget = canvasWidget
        self._locked = locked
        self._title = State(initialValue: canvasWidget.title ?? "")
    }
    
    var body: some View {
        
        HStack {
            
            InputBox(placeholder: Strings.titleLabel, text: $title)
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
            .onChange(of: colorScheme, perform: { _ in
                do {
                    let canvasView = PKCanvasView()
                    let imageView = UIImageView()
                    
                    canvasView.drawing = try PKDrawing(data: canvasWidget.pkDrawing ?? Data())
                    
                    canvasView.frame = CGRect(origin: .zero, size: CGSize(width: width, height: width))
                    canvasView.isOpaque = false
                    canvasView.backgroundColor = .clear
                    canvasView.minimumZoomScale = 1
                    canvasView.maximumZoomScale = 5
                    
                    imageView.frame = CGRect(origin: .zero, size: canvasView.frame.size)
                    imageView.contentMode = .scaleAspectFit
                    imageView.image = UIImage(data: canvasWidget.image ?? Data())
                    imageView.backgroundColor = colorScheme == .light ? .white : .systemGray6
                    
                    canvasView.addSubview(imageView)
                    canvasView.sendSubviewToBack(imageView)
                    
                    // Add picker
                    canvasView.becomeFirstResponder()
                    
                    FormModel.updateCanvasWidgetViewPreview(canvasWidget: canvasWidget, canvasView: canvasView)
                }
                catch {
                    title = Strings.updateCanvasWidgetViewPreviewErrorMessage
                    showAlert = true
                }
            })
            
            Button {
                reconfigureWidget = true
            } label: {
                if editMode?.wrappedValue == .active {
                    Image(systemName: Strings.editIconName)
                        .customIcon()
                }
            }
            .disabled(editMode?.wrappedValue == .inactive)
            .buttonStyle(.plain)
        }
        .sheet(isPresented: $reconfigureWidget) {
            ConfigureCanvasWidgetView(canvasWidget: canvasWidget, title: $title, section: canvasWidget.section!)
                .padding()
        }
        .alert(alertTitle, isPresented: $showAlert, actions: {
            Button(alertButtonDismissMessage, role: .cancel) {}
        })
    }
}

struct CanvasWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasWidgetView(canvasWidget: dev.canvasWidget, locked: .constant(false))
    }
}
