//
//  ConfigureCanvasWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/3/22.
//

import SwiftUI
import PhotosUI

// In new widget sheet to configure new CanvasWidget
struct ConfigureCanvasWidgetView: View {
    
    @EnvironmentObject var formModel: FormModel
    @Environment(\.dismiss) var dismiss
    @State var canvasWidget: CanvasWidget?
    @Binding var title: String
    @State var section: Section
    @State var sourceType: SourceType?
    @State var pickerResult: Data = Data()
    @State var photoPickerItem: PhotosPickerItem?
    
    var body: some View {
        
        VStack {
            Image(uiImage: UIImage(data: pickerResult) ?? UIImage())
                .resizable()
                .scaledToFit()
                .border(.black)
                .padding()
                .onAppear {
                    if let imageData = canvasWidget?.image {
                        pickerResult = imageData
                    }
                }
            
            Group {
                
                PhotosPicker(
                    selection: $photoPickerItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        Image(systemName: "photo.on.rectangle.angled")
                        Text("Select photo")
                    }
                    .onChange(of: photoPickerItem) { newItem in
                        Task {
                            // Retrieve selected asset in the form of Data
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                pickerResult = data
                            }
                        }
                    }
                
                Button {
                    sourceType = .camera
                } label: {
                    Image(systemName: "camera")
                    Text("Take photo")
                }
            }
            
            Button {
                if let canvasWidget {
                    canvasWidget.image = pickerResult
                }
                else {
                    withAnimation {
                        let canvasWidget = CanvasWidget(title: title, position: formModel.numberOfWidgetsInSection(section: section), image: pickerResult, pkDrawing: nil, widgetViewPreview: nil)
                        canvasWidget.image = pickerResult
                        
                        section.addToWidgets(canvasWidget)
                    }
                }
                dismiss()
            } label: {
                SubmitButton(isValid: .constant(true))
                    .padding(.bottom)
            }
        }
        .sheet(item: $sourceType) { type in
            switch type {
            case .camera:
                PhotoTaker(pickerResult: $pickerResult)
            case .photoLibrary:
                EmptyView()
            }
        }
    }
}

struct ConfigureCanvasWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureCanvasWidgetView(title: .constant(dev.canvasWidget.title!), section: dev.section)
    }
}
