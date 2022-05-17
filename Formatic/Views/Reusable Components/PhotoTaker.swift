//
//  PhotoTaker.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/14/22.
//

import SwiftUI

struct PhotoTaker: UIViewControllerRepresentable {
    
    @Binding var pickerResult: [PhotoWidget]
    
    typealias UIViewControllerType = UIImagePickerController
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
}

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var parent: PhotoTaker
    
    init(parent: PhotoTaker) {
        self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            self.parent.pickerResult.append(PhotoWidget(title: nil, position: self.parent.pickerResult.count, photo: image.jpegData(compressionQuality: 0.1)))
            picker.dismiss(animated: true)
        }
    }
}