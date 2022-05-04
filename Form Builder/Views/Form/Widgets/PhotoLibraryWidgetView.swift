//
//  PhotoLibraryWidgetView.swift
//  Form Builder
//
//  Created by Eli Hartnett on 5/1/22.
//

import SwiftUI

struct PhotoLibraryWidgetView: View {
    
    @ObservedObject var photoLibraryWidget: PhotoLibraryWidget
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct PhotoLibraryWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoLibraryWidgetView(photoLibraryWidget: dev.photoLibraryWidget)
    }
}
