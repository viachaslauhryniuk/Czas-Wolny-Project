//
// Login-Registration view-model
//  CzasWolny
//
//  
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth


final class UsersViewModel: ObservableObject{
    @ObservedObject private var viewModel = EmailVerificationViewModel()
    @ObservedObject private var viewModel2 = UserViewModel()
    
    
    //MARK: WELCOME SCREEN VARIABLES
    
    @Published var showLogRegView = false
    @Published var nextView: ViewStack = .login
    
    //-------------------------------------------
    
    
    //MARK: LOGIN VIEW VARIABLES
    @Published var appear = false
    @Published var appearBackground = false
    
    //FUNCTIONS
    func signInUser(completion: @escaping (Int) -> Void) {
        if !email.contains("@edu.p.lodz.pl"){
            email = "\(email)@edu.p.lodz.pl"
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                completion(1)
            } else {
                completion(0)
            }
        }
    }
    
    //MARK: REGISTRATION VIEW VARIABLES
    @Published var errorMessage = ""
    @Published var logoScale: CGFloat = 1.3
    @Published var logoOffset: CGFloat = 0.0
    @Published var textOpacity: Double = 0.0
    @Published var email = ""
    @Published var isLoading = false
    @Published var isEditing = false
    @Published var verifiCode = false
    @Published var errorShow = false
    @Published var existingStatus: Int = 0
    
    //MARK: FUNCTIONS
    
    func isValidEmail(_ email: String) -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@edu\\.p\\.lodz\\.pl"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailPattern)
        return emailTest.evaluate(with: email)
    }
    
    
    func checkIfUserExists(completion: @escaping (Int) -> Void) {
        let db = Firestore.firestore()
           db.collection("registeredEmails").whereField("email", isEqualTo: email)
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
    
    //--------------------------------------------------------------
    
    
    //MARK: EMAIL VERIFY VIEW VARIABLES
    
    @Published var enteredCode: [String] = Array(repeating: "", count: 6)
    @Published var lastEditedField: Int? = nil
    @Published var verificationStatus: Int = 0
    @Published var showCodeError = false
    @Published var shakeEffect = 0
    @Published var makePass = false
    
    
    //MARK: FUNCTIONS
    
    func sendEmail() {
            guard let request = createRequest() else {
                print("Invalid URL.")
                return
            }

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    let str = String(data: data, encoding: .utf8)
                    print("Received data:\n\(str ?? "")")
                }
            }
            
            task.resume()
    }
    

    func checkVerificationCode(completion: @escaping (Int) -> Void) {
        let db = Firestore.firestore()
        let collectionRef = db.collection("userscodes")
        collectionRef.whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
            var enterCode = self.enteredCode.joined()
            if let error = error {
                print("Error getting documents: \(error)")
                completion(-1) // Error occurred
            } else if let querySnapshot = querySnapshot, !querySnapshot.isEmpty {
                if let document = querySnapshot.documents.first, let code = document.data()["code"] as? String {
                    if code == enterCode {
                        completion(0) // Verification successful
                    } else {
                        completion(1) // Verification failed
                    }
                }
            } else {
                completion(-1) // Document does not exist
            }
        }
    }
    
    //-----------------------------------------------------------

    
    //MARK: PASSWORD MAKE VIEW VARIABLES
    
    
    @Published  var opacity: Double = 0
    @Published  var password = ""
    @Published  var confirmPassword = ""
    @Published var isBlue = false
    @Published  var showTips = false
    @Published var showError = false
    @Published var showPasswordError = false
    
    
    //FUNCTIONS
    
    func validatePassword(_ password: String) {
           let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$")
           if passwordTest.evaluate(with: password) {
               let user = User(email: self.email)
               viewModel2.addUser(user: user)
               Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                      if let error = error {
                          print("Error creating user: \(error.localizedDescription)")
                      } else {
                          print("User created successfully!")
                      }
                  }
               self.showPasswordError = false
           } else {
               self.showPasswordError = true
           }
       }
    
    
    //-------------------------------------------------------------
  
    
    
    //MARK: OTHER FUNCTIONS:
    @Published var transfer = false
    
    func createRequest() -> URLRequest? {
        guard let url = URL(string: "https://api.elasticemail.com/v2/email/send") else {
            return nil
        }
        var confirmationCode = Int.random(in: 100000..<1000000)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("5FC9ED7A0F8D171B08BBF7C7F343ADFE38511A17AA12A757EFBC8083CD6D3158296C48F382D5F1887311EB6B3B019BD7", forHTTPHeaderField: "X-ElasticEmail-ApiKey")
        
        let bodyData = "from=qwerty33566666@gmail.com&fromName=Viachaslau&subject=Your Verification Code&bodyText=Hey!\n Your verification code is \(confirmationCode)&to=\(self.email)&isTransactional=false"
        request.httpBody = bodyData.data(using: .utf8)
        let emailVerification = EmailVerification(email: "\(self.email)", code: "\(confirmationCode)", expiry: Timestamp(date: Date().addingTimeInterval(15*60)))
                    viewModel.addEmailVerification(emailVerification: emailVerification)
        return request
    }

    
   

    


    }
   

  


