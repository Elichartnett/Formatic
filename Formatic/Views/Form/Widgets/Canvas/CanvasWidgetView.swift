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
                if let backgroundImage = UIImage(data: canvasWidget.image ?? Data()) {
                    GeometryReader { proxy in
                        HStack {
                            Spacer()
                            
                            ZStack {
                                let proxyMin = min(proxy.size.width, proxy.size.height)
                                let targetSize = CGSize(width: proxyMin, height: proxyMin)
                                let resizedBackgroundImage = FormModel.resizeImage(image: backgroundImage, targetSize: targetSize) ?? UIImage()
                                
                                Image(uiImage: resizedBackgroundImage)
                                
                                Image(uiImage: UIImage(data: canvasWidget.widgetViewPreview ?? Data()) ?? UIImage())
                                    .resizable()
                                    .scaledToFit()
                            }
                            .border(.secondary)
                            
                            Spacer()
                        }
                    }
                }
            }
            .WidgetPreviewStyle()
            .onChange(of: colorScheme, perform: { _ in
                do {
                    let canvasView = PKCanvasView()
                    let imageView = UIImageView()
                    let width = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - 100
                    
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
