//
//  ImagePicker.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/14/22.
//

import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    var selectionLimit: Int
    @Binding var pickerResult: [PhotoWidget]
    
    func makeUIViewController(context: Context) -> some UIViewController {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = .images
        configuration.selectionLimit = selectionLimit
        
        let photoPickerViewController = PHPickerViewController(configuration: configuration)
        photoPickerViewController.delegate = context.coordinator
        return photoPickerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        private let parent: PhotoPicker
        
        init(parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.pickerResult.removeAll()
            for image in results {
                if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    image.itemProvider.loadObject(ofClass: UIImage.self) { newImage, error in
                        if let error = error {
                            print("Can't load image \(error.localizedDescription)")
                            print(error)
                        } else if let image = newImage as? UIImage {
                            let photoWidget = PhotoWidget(title: nil, position: self.parent.pickerResult.count, photo: image.jpegData(compressionQuality: 0.1))
                            self.parent.pickerResult.append(photoWidget)
                        }
                    }
                } else {
                    print("Can't load asset")
                }
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPicker(selectionLimit: 0, pickerResult: .constant([PhotoWidget]()))
    }
}
