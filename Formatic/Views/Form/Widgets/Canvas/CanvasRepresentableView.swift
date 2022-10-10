//
//  CanvasRepresentableView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/15/22.
//
import SwiftUI
import PencilKit

struct CanvasRepresentable: UIViewRepresentable {
    
    @State var canvasWidget: CanvasWidget
    @State var canvasView: PKCanvasView = PKCanvasView()
    let imageView = UIImageView()
    let toolPicker: PKToolPicker = PKToolPicker()
    @Binding var showAlert: Bool
    @Binding var alertTitle: String
    let width: Double
    
    func makeUIView(context: Context) -> PKCanvasView {
        // Customize canvas
        do {
            if let pkDrawingData = canvasWidget.pkDrawing {
                try canvasView.drawing = PKDrawing(data: pkDrawingData)
            }
        }
        catch {
            DispatchQueue.main.async {
                alertTitle = "Error importing canvas"
                showAlert = true
            }
        }
        canvasView.frame = CGRect(origin: .zero, size: CGSize(width: width, height: width))
        canvasView.isOpaque = false
        canvasView.backgroundColor = .clear
        canvasView.minimumZoomScale = 1
        canvasView.maximumZoomScale = 5
        
        imageView.frame = CGRect(origin: .zero, size: canvasView.frame.size)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(data: canvasWidget.image ?? Data())
        imageView.backgroundColor = .white
        
        canvasView.addSubview(imageView)
        canvasView.sendSubviewToBack(imageView)
        
        // Add picker
        canvasView.becomeFirstResponder()
        toolPicker.addObserver(canvasView)
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        
        canvasView.delegate = context.coordinator
        
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
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
            parent.canvasWidget.widgetViewPreview = canvasView.drawing.image(from: CGRect(origin: .zero, size: canvasView.frame.size), scale: UIScreen.main.scale).pngData()
        }
        
        // Sends updates from UIView to SwiftUI
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            let zoom = parent.canvasView.zoomScale
            let canvasViewSize = parent.canvasView.frame.size
            parent.imageView.frame = CGRect(origin: .zero, size: CGSize(width: canvasViewSize.width * zoom, height: canvasViewSize.height * zoom))
        }
    }
}
