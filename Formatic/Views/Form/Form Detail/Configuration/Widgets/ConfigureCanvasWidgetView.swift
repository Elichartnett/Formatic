//
//  ConfigureCanvasWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/3/22.
//
import SwiftUI
import PhotosUI
import FirebaseAnalytics

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
                .border(pickerResult == Data() ? .clear : .secondary)
                .WidgetFrameStyle(height: .large)
                .onAppear {
                    if let imageData = canvasWidget?.image {
                        pickerResult = imageData
                    }
                }
                .accessibilityHidden(pickerResult == Data())
            
            Group {
                
                PhotosPicker(
                    selection: $photoPickerItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        Image(systemName: Constants.photoFrameIconName)
                        Text(Strings.selectPhotoLabel)
                    }
                    .onChange(of: photoPickerItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                pickerResult = data
                            }
                        }
                    }
                
                Button {
                    sourceType = .camera
                } label: {
                    Image(systemName: Constants.cameraIconName)
                    Text(Strings.takePhotoLabel)
                }
            }
            
            Button {
                if let canvasWidget {
                    canvasWidget.image = pickerResult
                }
                else {
                    withAnimation {
                        let canvasWidget = CanvasWidget(title: title, position: section.numberOfWidgets(), image: pickerResult, pkDrawing: nil, widgetViewPreview: nil)
                        canvasWidget.image = pickerResult
                        
                        section.addToWidgets(canvasWidget)
                    }
                    Analytics.logEvent(Constants.analyticsCreateCanvasWidgetEvenet, parameters: nil)
                }
                dismiss()
            } label: {
                SubmitButton()
                    .padding(.bottom)
            }
        }
        .sheet(item: $sourceType) { type in
            switch type {
            case .camera:
                PhotoTaker(pickerResult: $pickerResult)
                    .ignoresSafeArea()
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
