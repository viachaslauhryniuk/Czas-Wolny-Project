import Foundation

import FirebaseFirestore
struct Task: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var description: String
    var group: String
    var deadline: Timestamp
}
