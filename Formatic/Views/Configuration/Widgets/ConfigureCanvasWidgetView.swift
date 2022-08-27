//
//  ConfigureCanvasWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/3/22.
//

import SwiftUI

// In new widget sheet to configure new CanvasWidget
struct ConfigureCanvasWidgetView: View {
    
    @EnvironmentObject var formModel: FormModel
    @Environment(\.dismiss) var dismiss

    @Binding var title: String
    @State var section: Section
    @State var sourceType: SourceType?
    @State var pickerResult: Data = Data()
    
    var body: some View {
        
        VStack {
            Image(uiImage: UIImage(data: pickerResult) ?? UIImage())
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
                    let canvasWidget = CanvasWidget(title: title, position: formModel.numberOfWidgetsInSection(section: section))
                        canvasWidget.image = pickerResult
                    
                    section.addToWidgets(canvasWidget)
                    DataController.saveMOC()
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
                PhotoPicker()
            }
        }
    }
}

struct ConfigureCanvasWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureCanvasWidgetView(title: .constant(dev.canvasWidget.title!), section: dev.section)
    }
}
