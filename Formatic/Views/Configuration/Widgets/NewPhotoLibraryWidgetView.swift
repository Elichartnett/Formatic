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
    
    @Binding var newWidgetType: WidgetType?
    @Binding var title: String
    @State var section: Section
    @State var sourceType: SourceType?
    @State var pickerResult: [PhotoWidget] = [PhotoWidget]()
    
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
            .onChange(of: pickerResult) { _ in
                if pickerResult.count == 2 {
                    pickerResult[0] = pickerResult[1]
                    pickerResult.remove(at: 1)
                }
            }
            
            Button {
                let photoLibraryWidget = PhotoLibraryWidget(title: title, position: section.widgetsArray.count)
                if pickerResult.count == 1 {
                    photoLibraryWidget.addToPhotos(pickerResult.first!)
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
    }
}

struct NewPhotoLibraryWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        NewPhotoLibraryWidgetView(newWidgetType: .constant(.photoLibraryWidget), title: .constant(dev.photoLibraryWidget.title!), section: dev.section)
    }
}
