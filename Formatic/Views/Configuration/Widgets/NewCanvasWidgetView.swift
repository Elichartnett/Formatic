//
//  NewCanvasWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/3/22.
//

import SwiftUI

// In new widget sheet to configure new CanvasWidget
struct NewCanvasWidgetView: View {
    
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
                withAnimation {
                    let canvasWidget = CanvasWidget(title: title, position: section.widgetsArray.count)
                    if pickerResult.count == 1 {
                        let backgroundPhoto = pickerResult.first?.photo
                        canvasWidget.image = backgroundPhoto
                    }
                    else {
                        canvasWidget.image = UIImage().jpegData(compressionQuality: 0.1)
                    }
                    
                    section.addToWidgets(canvasWidget)
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

struct NewCanvasWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        NewCanvasWidgetView(newWidgetType: .constant(.canvasWidget), title: .constant(dev.canvasWidget.title!), section: dev.section)
    }
}
