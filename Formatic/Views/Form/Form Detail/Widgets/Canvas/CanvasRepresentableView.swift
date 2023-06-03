//
//  CanvasRepresentableView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/15/22.
//
import SwiftUI
import PencilKit

struct CanvasRepresentable: UIViewRepresentable {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var canvasWidget: CanvasWidget
    @State var canvasView: PKCanvasView = PKCanvasView()
    @State var imageView = UIImageView()
    @State var toolPicker: PKToolPicker = PKToolPicker()
    @Binding var showAlert: Bool
    @Binding var alertTitle: String
    let width: Double
    
    func makeUIView(context: Context) -> PKCanvasView {
        do {
            if let pkDrawingData = canvasWidget.pkDrawing {
                try canvasView.drawing = PKDrawing(data: pkDrawingData)
            }
        }
        catch {
            DispatchQueue.main.async {
                alertTitle = Strings.importCanvasErrorMessage
                showAlert = true
            }
        }

        canvasWidget.setUpCanvas(canvasView: canvasView, imageView: imageView, toolPicker: toolPicker, width: width)
        
        canvasView.delegate = context.coordinator
        
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        DispatchQueue.main.async {
            imageView.backgroundColor = .secondaryBackground
            toolPicker.colorUserInterfaceStyle = UIUserInterfaceStyle(colorScheme)
            toolPicker.overrideUserInterfaceStyle = UIUserInterfaceStyle(colorScheme)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        
        var parent: CanvasRepresentable
        
        init(parent: CanvasRepresentable) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            parent.canvasWidget.pkDrawing = canvasView.drawing.dataRepresentation()
            CanvasWidget.updateWidgetViewPreview(canvasWidget: parent.canvasWidget, updatedData: parent.canvasView.drawing.dataRepresentation())
        }
        
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            let zoom = parent.canvasView.zoomScale
            let canvasViewSize = parent.canvasView.frame.size
            parent.imageView.frame = CGRect(origin: .zero, size: CGSize(width: canvasViewSize.width * zoom, height: canvasViewSize.height * zoom))
        }
    }
}
