//
//  ImagePicker.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/14/22.
//

import SwiftUI
import PhotosUI

struct PhotoPicker: View {
    
    @Environment(\.dismiss) private var dismiss
    @Binding var pickerResult: Data
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()) {
                Text("Select a photo")
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    // Retrieve selected asset in the form of Data
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        pickerResult = data
                    }
                }
                dismiss()
            }
    }
}

struct ImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPicker(pickerResult: .constant(Data()))
    }
}
