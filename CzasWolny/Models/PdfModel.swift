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
class ImageLoader: ObservableObject {
    @Published var imageData: Data = Data()

    func fetchImage(url: String) {
        guard let imageUrl = URL(string: url) else {
            return
        }

        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                self.imageData = data
            }
        }.resume()
    }
}



class ScheduleLoader: ObservableObject {
    var schedules: [String: String] = [:]

    init() {
        if let url = Bundle.main.url(forResource: "schedules", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let parsedSchedules = try? JSONSerialization.jsonObject(with: data) as? [String: String] {
            self.schedules = parsedSchedules
        }
    }

    func getUrl(forGroup group: String) -> String? {
        return schedules[group]
    }
}
