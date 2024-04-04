import FirebaseFirestore
import Foundation
import FirebaseAuth

final class GroupViewModel: ObservableObject
{
    @Published  var groupName = ""
    @Published  var memberEmail = ""
    @Published var creatorEmail = ""
    @Published var groups:[String] = []
    @Published var members: [String] = []
    @Published var existingStatus: Int = -1
    let db = Firestore.firestore()
    
    func getUserEmail(){
        if let user = Auth.auth().currentUser {
            self.creatorEmail = user.email!
        } else {
        // No user is signed in.
        }
    }
    func checkIfUserExists(completion: @escaping (Int) -> Void) {
        let db = Firestore.firestore()
           db.collection("registeredEmails").whereField("email", isEqualTo: memberEmail)
               .getDocuments() { (querySnapshot, err) in
                   if let err = err {
                       print("Error getting documents: \(err)")
                   } else if querySnapshot!.documents.count != 0 {
                      completion(1)
                   } else {
                      completion(0)
                   }
               }
       }
    func createGroup() {
           let db = Firestore.firestore()
           
            var allMembers = members
            allMembers.append(creatorEmail)
           db.collection("group").addDocument(data: [
               "groupName": self.groupName,
               "members": allMembers
           ]) { err in
               if let err = err {
                   print("Error adding document: \(err)")
               } else {
                   print("Group created successfully.")
               }
           }
       }
    func loadGroups() {
        let db = Firestore.firestore()
        db.collection("group").whereField("members", arrayContains: creatorEmail).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.groups = querySnapshot!.documents.compactMap { $0["groupName"] as? String }
            }
        }
    }
        }



