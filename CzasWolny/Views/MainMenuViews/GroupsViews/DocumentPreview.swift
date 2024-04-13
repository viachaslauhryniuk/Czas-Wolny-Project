//
//  DocumentPreview.swift
//  CzasWolny
//
//  Created by Слава Гринюк on 4.04.24.
//
import UIKit
import SwiftUI
import Foundation
import QuickLook

struct DocumentPreview: UIViewControllerRepresentable {
    var url: URL

    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: QLPreviewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, QLPreviewControllerDataSource {
        var parent: DocumentPreview

        init(_ qlPreviewController: DocumentPreview) {
            self.parent = qlPreviewController
            super.init()
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return parent.url as NSURL
        }
    }
}
