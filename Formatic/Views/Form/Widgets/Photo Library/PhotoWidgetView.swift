//
//  PhotoWidgetView.swift
//  Formatic
//
//  Created by Eli Hartnett on 5/22/22.
//

import SwiftUI

struct PhotoWidgetView: View {
    
    @State var photoWidget: PhotoWidget
    @Binding var showTitle: Bool
    
    var body: some View {
        LazyVStack {
            Image(uiImage: UIImage(data: photoWidget.photoThumbnail ?? Data()) ?? UIImage())
                .resizable()
                .scaledToFit()

            InputBox(placeholder: "Title", text: .constant(""))
                .opacity(showTitle ? 1 : 0)
        }
    }
}

struct PhotoWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoWidgetView(photoWidget: dev.photoWidget, showTitle: .constant(true))
    }
}
