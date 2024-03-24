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

class UserViewModel: ObservableObject {
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
   
    @Published var users = User.self

    func addUser(user: User) {
        do {
            _ = try db.collection("users").addDocument(from: user)
        }
        catch {
            print("There was an error while trying to save a task \(error.localizedDescription).")
        }
    }
}

