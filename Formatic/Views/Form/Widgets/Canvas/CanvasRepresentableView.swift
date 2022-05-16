////
////  CanvasRepresentableView.swift
////  Formatic
////
////  Created by Eli Hartnett on 5/15/22.
////
//
//import SwiftUI
//import PencilKit
//
//struct CanvasRepresentable: UIViewRepresentable {
//    
//    @Binding var widget: CanvasWidget
//    var width: CGFloat
//    let toolPicker = PKToolPicker()
//    
//    func makeUIView(context: Context) -> PKCanvasView {
//        
//        if widget.PKCanvas == nil {
//            
//            // Create canvas
//            widget.PKCanvas = PKCanvasView()
//            
//            // Customize canvas
//            widget.PKCanvas!.isOpaque = false
//            widget.PKCanvas!.backgroundColor = .clear
//            widget.PKCanvas!.minimumZoomScale = 1
//            widget.PKCanvas!.maximumZoomScale = 5
//        }
//        
//        if widget.imageView == nil {
//            
//            // Create image view
//            widget.imageView = UIImageView(image: widget.image)
//            
//            // Customize image view
//            widget.imageView!.frame.size.width = width * widget.PKCanvas!.zoomScale
//            widget.imageView!.frame.size.height = width * widget.PKCanvas!.zoomScale
//            widget.imageView!.contentMode = .scaleAspectFit
//        }
//        
//        widget.PKCanvas!.addSubview(widget.imageView!)
//        widget.PKCanvas!.sendSubviewToBack(widget.imageView!)
//        
//        // Add picker
//        widget.PKCanvas!.becomeFirstResponder()
//        widget.PKCanvas!.delegate = context.coordinator
//        toolPicker.addObserver(widget.PKCanvas!)
//        toolPicker.setVisible(true, forFirstResponder: widget.PKCanvas!)
//        
//        return widget.PKCanvas!
//    }
//    
//    func updateUIView(_ uiView: PKCanvasView, context: Context) {
//        
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(widget: $widget, width: width)
//    }
//    
//    class Coordinator: NSObject, PKCanvasViewDelegate {
//        
//        @Binding var widget: CanvasWidget
//        var width: CGFloat
//        
//        init(widget: Binding<CanvasWidget>, width: CGFloat) {
//            self._widget = widget
//            self.width = width
//        }
//        
//        // Sends updates from UIView to SwiftUI
//        func scrollViewDidZoom(_ scrollView: UIScrollView) {
//            widget.imageView!.frame.size.width = width * widget.PKCanvas!.zoomScale
//            widget.imageView!.frame.size.height = width * widget.PKCanvas!.zoomScale
//        }
//    }
//}
