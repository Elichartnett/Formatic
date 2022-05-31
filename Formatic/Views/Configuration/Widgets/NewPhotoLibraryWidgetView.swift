//
//  NewPhotoLibraryWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/3/22.
//

import SwiftUI
import Combine

// In new widget sheet to configure new PhotoLibraryWidget
struct NewPhotoLibraryWidgetView: View {
    
    @EnvironmentObject var formModel: FormModel
    
    @Binding var newWidgetType: WidgetType?
    @Binding var title: String
    @State var section: Section
    @State var sourceType: SourceType?
    @State var pickerResult: [PhotoWidget] = [PhotoWidget]()
    @State var showAlert: Bool = false
    @State var alertTitle: String = ""
    @State var alertButtonTitle: String = "Okay"
    
    var body: some View {
        
        VStack {

            Image(uiImage: UIImage(data: (pickerResult.first?.photo ?? Data())) ?? UIImage())
                .resizable()
                .scaledToFit()
                .border(.black)
                .padding()
            
            Group {
                Button {
                    sourceType = .photoLibrary
                } label: {
                    Image(systemName: "photo.on.rectangle.angled")
                    Text("Select photo")
                }
                
                Button {
                    sourceType = .camera
                } label: {
                    Image(systemName: "camera")
                    Text("Take photo")
                }
            }
            
            Button {
                let photoLibraryWidget = PhotoLibraryWidget(title: title, position: formModel.numberOfWidgetsInSection(section: section))
                if let photoWidget = pickerResult.first {
                    do {
                        let photoThumbnail = try formModel.resizeImage(imageData: pickerResult.first!.photo!, newSize: CGSize(width: 200, height: 200))
                        photoWidget.photoThumbnail = photoThumbnail
                        photoLibraryWidget.addToPhotoWidgets(photoWidget)
                    }
                    catch {
                        alertTitle = "Error importing photo"
                        showAlert = true
                    }
                }
                
                withAnimation {
                    section.addToWidgets(photoLibraryWidget)
                    DataController.saveMOC()
                }
                newWidgetType = nil
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
                PhotoPicker(selectionLimit: 1, pickerResult: $pickerResult)
            }
        }
        .alert(alertTitle, isPresented: $showAlert, actions: {
            Button(alertButtonTitle, role: .cancel) {}
        })
    }
}

struct NewPhotoLibraryWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        NewPhotoLibraryWidgetView(newWidgetType: .constant(.photoLibraryWidget), title: .constant(dev.photoLibraryWidget.title!), section: dev.section)
    }
}
