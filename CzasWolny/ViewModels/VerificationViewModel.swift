import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI
class EmailVerificationViewModel: ObservableObject {
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
   
    @Published var emailVerifications = EmailVerification.self

    func addEmailVerification(emailVerification: EmailVerification) {
        do {
            _ = try db.collection("userscodes").addDocument(from: emailVerification)
        }
        catch {
            print("There was an error while trying to save a task \(error.localizedDescription).")
        }
    }
}

