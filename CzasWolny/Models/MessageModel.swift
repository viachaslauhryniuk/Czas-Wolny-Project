//
//  MessageModel.swift
//  CzasWolny
//
//  Created by Слава Гринюк on 3.04.24.
//

import Foundation
struct Message: Identifiable {
    let id = UUID()
    let sender: String
    let content: String
    var isFile: Bool
}
class IdentifiableURL: Identifiable {
    let id = UUID()
    let url: URL

    init(url: URL) {
        self.url = url
    }
}
