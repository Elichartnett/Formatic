//
//  PhotoLibraryWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct PhotoLibraryWidgetView: View {
    
    @ObservedObject var photoLibraryWidget: PhotoLibraryWidget
    @Binding var locked: Bool
    @State var title: String = ""
    
    init(photoLibraryWidget: PhotoLibraryWidget, locked: Binding<Bool>) {
        self.photoLibraryWidget = photoLibraryWidget
        self._locked = locked
    }

    var body: some View {
        
        HStack {
            InputBox(placeholder: "Title", text: $title)
                .titleFrameStyle(locked: $locked)
                .onChange(of: title) { _ in
                    photoLibraryWidget.title = title
                }
                .onAppear {
                    title = photoLibraryWidget.title ?? ""
                }
            
            Spacer()
            
            NavigationLink {
                PhotoLibraryWidgetDetailView(photoLibraryWidget: photoLibraryWidget)
            } label: {
                Spacer()
                Image(uiImage: UIImage(data: (photoLibraryWidget.photosArray.first?.photo) ?? Data()) ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .DetailFrameStyle()
                Spacer()
            }
        }
    }
}

struct PhotoLibraryWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoLibraryWidgetView(photoLibraryWidget: dev.photoLibraryWidget, locked: .constant(false))
    }
}
