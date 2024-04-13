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
    @GestureState private var zoomScale: CGFloat = 1.0
        @GestureState private var dragOffset: CGSize = .zero
        @State private var effectiveZoomScale: CGFloat = 1.0
        @State private var effectiveDragOffset: CGSize = .zero
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
                .scaleEffect(effectiveZoomScale * zoomScale)
                           .offset(x: (effectiveDragOffset.width + dragOffset.width), y: (effectiveDragOffset.height + dragOffset.height))
                           .gesture(
                               MagnificationGesture()
                                   .updating($zoomScale) { currentState, gestureState, _ in
                                       gestureState = currentState
                                   }
                                   .onEnded { value in
                                       self.effectiveZoomScale *= value
                                       self.effectiveZoomScale = max(1.0, self.effectiveZoomScale)
                                   }
                           )
                           .simultaneousGesture(
                               DragGesture()
                                   .updating($dragOffset) { currentState, gestureState, _ in
                                       gestureState = currentState.translation
                                   }
                                   .onEnded { value in
                                       self.effectiveDragOffset.width += value.translation.width
                                       self.effectiveDragOffset.height += value.translation.height
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
