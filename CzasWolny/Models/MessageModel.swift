//
//  MessageModel.swift
//  CzasWolny
//
//  Created by Слава Гринюк on 3.04.24.
//

import Foundation
import SwiftUI
struct Message: Identifiable , Hashable{
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
struct ChatBubble: Shape {
    var isFromCurrentUser: Bool

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: [.topLeft, .topRight, isFromCurrentUser ? .bottomLeft : .bottomRight],
                                cornerRadii: CGSize(width: 25, height: 25))

        return Path(path.cgPath)
    }
}

