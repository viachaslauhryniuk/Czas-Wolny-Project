//
//  PdfViewModel.swift
//  CzasWolny
//
//  Created by Слава Гринюк on 28.03.24.
//

import Foundation
import PDFKit
import SwiftUI
struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        pdfView.backgroundColor = .white
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the view if needed
    }
}
