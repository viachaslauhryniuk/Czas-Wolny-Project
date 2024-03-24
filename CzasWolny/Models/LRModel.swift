//
//  Login-Registration model
//  CzasWolny
//
// 
//

import Foundation
import FirebaseFirestore
import SwiftUI

enum ViewStack{
    case login
    case registration
}


struct ApiResponse: Decodable {
    struct Data: Decodable {
        let status: String
    }
    let data: Data
}


struct EmailVerification: Identifiable, Codable{
    var id = UUID()
    var email: String
    var code: String
    var expiry: Timestamp
}





