//
//  PhotoLibraryWidgetDetailView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/14/22.
//

import SwiftUI

struct PhotoLibraryWidgetDetailView: View {
    
    @ObservedObject var photoLibraryWidget: PhotoLibraryWidget
    @State var sourceType: SourceType?
    @State var showTitles: Bool = false
    let columns: [GridItem] = Array(repeating: GridItem(.adaptive(minimum: 200), spacing: nil, alignment: nil), count: 1)
    @State var pickerResult: [PhotoWidget] = [PhotoWidget]()
    
    var body: some View {
        
        ScrollView {
            
            LazyVGrid(columns: columns) {
                ForEach(pickerResult.sorted(by: { lhs, rhs in
                    lhs.position < rhs.position
                })) { photoWidget in
                    VStack {
                        Image(uiImage: UIImage(data: photoWidget.photo ?? Data()) ?? UIImage())
                            .resizable()
                            .scaledToFit()
                        
                        InputBox(placeholder: "Title", text: .constant(""))
                            .opacity(showTitles ? 1 : 0)
                    }
                }
            }
            .onAppear {
                pickerResult = photoLibraryWidget.photosArray
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(photoLibraryWidget.title ?? "")
        .toolbar(content: {
            ToolbarItem(placement: .automatic) {
                HStack {
                    
                    Toggle("Show titles", isOn: $showTitles)
                        .onAppear(perform: {
                            showTitles = photoLibraryWidget.showTitles
                        })
                        .onChange(of: showTitles) { newValue in
                            photoLibraryWidget.showTitles = newValue
                            DataController.saveMOC()
                        }
                    
                    Button {
                        sourceType = .photoLibrary
                    } label: {
                        Image(systemName: "photo.on.rectangle.angled")
                        Text("Select photos")
                    }
                    
                    Button {
                        sourceType = .camera
                    } label: {
                        Image(systemName: "camera")
                        Text("Take photo")
                    }
                }
                .onChange(of: pickerResult) { _ in
                    for result in pickerResult {
                        if !photoLibraryWidget.photosArray.contains(where: { photoWidget in
                            photoWidget.id == result.id
                        }) {
                            photoLibraryWidget.addToPhotos(result)
                        }
                    }
                    DataController.saveMOC()
                }
            }
        })
        .padding()
        .sheet(item: $sourceType) { type in
            switch type {
            case .camera:
                PhotoTaker(pickerResult: $pickerResult)
            case .photoLibrary:
                PhotoPicker(selectionLimit: 0, pickerResult: $pickerResult)
            }
        }
    }
}

struct PhotoLibraryWidgetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PhotoLibraryWidgetDetailView(photoLibraryWidget: dev.photoLibraryWidget)
        }
        .navigationViewStyle(.stack)
    }
}
