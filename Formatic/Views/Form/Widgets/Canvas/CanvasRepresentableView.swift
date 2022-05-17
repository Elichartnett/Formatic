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
    @State var size: Double
    @State var canvasView: PKCanvasView = PKCanvasView()
    let toolPicker: PKToolPicker = PKToolPicker()
    
    func makeUIView(context: Context) -> PKCanvasView {
        
        // Customize canvas
        do {
            try canvasView.drawing = PKDrawing(data: canvasWidget.pkDrawing ?? Data())
        }
        catch {
            print("Failed to import drawing data: \(error)")
        }
        canvasView.frame = CGRect(origin: .zero, size: CGSize(width: size, height: size))
        canvasView.isOpaque = false
        canvasView.backgroundColor = .clear
        canvasView.minimumZoomScale = 1
        canvasView.maximumZoomScale = 5
        
        let imageView = UIImageView()
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: size, height: size))
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(data: canvasWidget.image ?? Data())
        
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
            DataController.saveMOC()
        }
        
        // Sends updates from UIView to SwiftUI
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
//            parent.imageView.frame = CGRect(origin: .zero, size: CGSize(width: parent.size * parent.canvasView.zoomScale, height: parent.size * parent.canvasView.zoomScale))
        }
    }
}
