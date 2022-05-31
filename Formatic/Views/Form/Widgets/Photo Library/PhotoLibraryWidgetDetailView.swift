//
//  PhotoLibraryWidgetDetailView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/14/22.
//

import SwiftUI

struct PhotoLibraryWidgetDetailView: View {
    
    @FetchRequest var photoLibrary: FetchedResults<PhotoWidget>
    @EnvironmentObject var formModel: FormModel
    @ObservedObject var photoLibraryWidget: PhotoLibraryWidget
    
    @GestureState var magnifyBy: Double = 1
    @State var selectedPhotoWidget: PhotoWidget?
    @State var sourceType: SourceType?
    @State var showTitles: Bool = false
    let columns: [GridItem] = [GridItem(.adaptive(minimum: 200), spacing: nil, alignment: nil)]
    @State var pickerResult: [PhotoWidget] = [PhotoWidget]()
    @State var showTabView: Bool = false
    @State var showAlert: Bool = false
    @State var alertTitle: String = ""
    @State var alertButtonTitle: String = "Okay"
    
    init(photoLibraryWidget: PhotoLibraryWidget) {
        self._photoLibrary = FetchRequest(sortDescriptors: [SortDescriptor(\.position)], predicate: NSPredicate(format: "photoLibraryWidget == %@", photoLibraryWidget))
        self.photoLibraryWidget = photoLibraryWidget
    }
    
    var body: some View {
        
        ZStack {
            ScrollView {
                
                LazyVGrid(columns: columns) {
                    ForEach(photoLibrary) { photoWidget in
                        PhotoWidgetView(photoWidget: photoWidget, showTitle: $showTitles)
                            .frame(width: 200, height: 200)
                            .padding()
                            .onTapGesture {
                                showTabView = true
                                selectedPhotoWidget = photoWidget
                            }
                    }
                }
            }
            
            if showTabView {
                TabView(selection: $selectedPhotoWidget, content: {
                    ForEach(0..<photoLibrary.count, id: \.self) { index in
                        Image(uiImage: UIImage(data: photoLibrary[index].photo ?? Data()) ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .scaleEffect(magnifyBy)
                            .gesture(
                                MagnificationGesture()
                                    .updating($magnifyBy, body: { currentState, gestureState, transaction in
                                        gestureState = currentState
                                    })
                            )
                    }
                })
                .tabViewStyle(.page)
                .background(
                    Rectangle()
                        .fill(Material.thinMaterial)
                        .ignoresSafeArea()
                        .opacity(showTabView ? 1 : 0)
                        .onTapGesture {
                            selectedPhotoWidget = nil
                        }
                )
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
                    for photoWidget in pickerResult {
                        do {
                            let photoThumbnail = try formModel.resizeImage(imageData: photoWidget.photo!, newSize: CGSize(width: 200, height: 200))
                            photoWidget.photoThumbnail = photoThumbnail
                            photoWidget.position = Int16(photoLibrary.count)
                            photoLibraryWidget.addToPhotoWidgets(photoWidget)
                        }
                        catch {
                            alertTitle = "Error importing photo"
                            showAlert = true
                        }
                    }
                    DataController.saveMOC()
                }
            }
        })
        .padding(.top)
        .sheet(item: $sourceType) { type in
            switch type {
            case .camera:
                PhotoTaker(pickerResult: $pickerResult)
            case .photoLibrary:
                PhotoPicker(selectionLimit: 0, pickerResult: $pickerResult)
            }
        }
        .alert(alertTitle, isPresented: $showAlert, actions: {
            Button(alertButtonTitle, role: .cancel) {}
        })
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
