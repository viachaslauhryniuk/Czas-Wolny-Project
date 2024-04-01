//
//  ImageView.swift
//  CzasWolny
//
//  Created by Слава Гринюк on 1.04.24.
//

import SwiftUI

struct ImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    let placeholder: Image
    @State private var scale: CGFloat = 1.0
      @State private var offset = CGSize.zero
      @State private var lastOffset = CGSize.zero
    init(url: String, placeholder: Image = Image(systemName: "hourglass")) {
        self.placeholder = placeholder
        self.imageLoader = ImageLoader()
        self.imageLoader.fetchImage(url: url)
    }

    var body: some View {
        if let uiImage = UIImage(data: self.imageLoader.imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(scale)
                           .offset(x: offset.width, y: offset.height)
                           .gesture(
                               MagnificationGesture()
                                   .onChanged { value in
                                       self.scale = max(1.0, value.magnitude)
                                   }
                           )
                           .simultaneousGesture(
                               DragGesture()
                                   .onChanged { value in
                                       self.offset = CGSize(width: value.translation.width + self.lastOffset.width, height: value.translation.height + self.lastOffset.height)
                                   }
                                   .onEnded { value in
                                       self.lastOffset = self.offset
                                   }
                           )
        } else {
            placeholder
                .scaleEffect(1.5)
                .aspectRatio(contentMode: .fit)
        }
    }
}


#Preview {
    ImageView(url: "")
}
