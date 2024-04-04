import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import UniformTypeIdentifiers
struct GroupView: View {
    @EnvironmentObject var vm: GroupViewModel
    let groupId: String
    @State var messages: [Message] = []
    @State var newMessage = ""
    @State private var isShowingFilePicker = false
    @State private var inputImage: URL?
    @State private var selectedFile: IdentifiableURL? = nil
    @State var existEmoji = false
    var body: some View {
        VStack {
            List(messages) { message in
                if message.isFile {
                    if let url = URL(string: message.content), url.pathExtension.lowercased() == "jpg" || url.pathExtension.lowercased() == "png" {
                        HStack{
                            Text(message.sender)
                            AsyncImage(url: url) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    } else {

                        Button(action: {
                            let url = URL(string: message.content)!
                            let localURL = FileManager.default.temporaryDirectory.appendingPathComponent(url.lastPathComponent)
                            if FileManager.default.fileExists(atPath: localURL.path) {
                                self.existEmoji = true
                                self.selectedFile = IdentifiableURL(url: localURL)
                            } else {
                                self.existEmoji = false
                                let storageRef = Storage.storage().reference(forURL: url.absoluteString)
                                storageRef.write(toFile: localURL) { url, error in
                                    if let url = url {
                                        self.selectedFile = IdentifiableURL(url: url)
                                    } else if let error = error {
                                        print("Error downloading file: \(error)")
                                    }
                                }
                            }
                        }) {
                            HStack {
                                Text("\(message.sender): File")
                                Image(systemName: self.existEmoji ? "eye" : "square.and.arrow.down")
                            }
                        }
                        .sheet(item: $selectedFile) { identifiableURL in
                            DocumentPreview(url: identifiableURL.url)
                        }

                    }
                } else {
                    Text("\(message.sender): \(message.content)")
                }
            

            }
            .onAppear(perform: loadMessages)
            
            
            HStack {
                TextField("New Message", text: $newMessage)
                Button(action: sendMessage) {
                    Text("Send")
                }
                Button(action: {
                    self.isShowingFilePicker = true
                }) {
                    Text("Upload File")
                }
                .fileImporter(
                    isPresented: $isShowingFilePicker,
                    allowedContentTypes: [UTType.data],
                    allowsMultipleSelection: false
                ) { result in
                    switch result {
                    case .success(let urls):
                        guard let url = urls.first else { return }
                        self.inputImage = url
                        if fileExists(at: url) {
                            print("File exists")
                        } else {
                            print("File does not exist")
                        }
                        uploadFile(url: url)
                    case .failure(let error):
                        print("Error reading document: \(error)")
                    }
                }
            }
        }
        .navigationBarTitle("Group Chat", displayMode: .inline)
    }
    
    func loadMessages() {
        let db = Firestore.firestore()
        db.collection("messages")
            .whereField("groupId", isEqualTo: groupId)
            .order(by: "timestamp")
            .addSnapshotListener { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.messages = querySnapshot!.documents.compactMap { doc in
                        let sender = doc["sender"] as? String ?? ""
                        let content = doc["content"] as? String ?? ""
                        let isFile = URL(string: content)?.scheme != nil
                        return Message(sender: sender, content: content, isFile: isFile)
                    }
                }
            }
    }
    
    
    func sendMessage() {
        let db = Firestore.firestore()
        db.collection("messages").addDocument(data: [
            "groupId": groupId,
            "sender": Auth.auth().currentUser?.email ?? "",
            "content": newMessage,
            "timestamp": FieldValue.serverTimestamp()
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                self.newMessage = ""
            }
        }
    }
    
    func uploadFile(url: URL) {
        guard url.startAccessingSecurityScopedResource() else {
               // Handle the failure here according to your app's needs
               return
           }

           defer { url.stopAccessingSecurityScopedResource() }
        let fileManager = FileManager.default
        let localURL = fileManager.temporaryDirectory.appendingPathComponent(url.lastPathComponent)

        do {
            if fileManager.fileExists(atPath: localURL.path) {
                try fileManager.removeItem(at: localURL)
            }
            try fileManager.copyItem(at: url, to: localURL)
        } catch {
            print("Failed to copy file: \(error)")
            return
        }

        let storage = Storage.storage().reference().child("Objects/\(localURL.lastPathComponent)")
        storage.putFile(from: localURL, metadata: nil) { (_, error) in
            if let error = error {
                print("Error uploading file: \(error)")
            } else {
                storage.downloadURL { (url, error) in
                    if let error = error {
                        print("Error getting download URL: \(error)")
                    } else if let downloadURL = url {
                        self.newMessage = downloadURL.absoluteString
                        self.sendMessage()
                    }
                }
            }
        }
    }

    func fileExists(at url: URL) -> Bool {
        let path = url.path
        return FileManager.default.fileExists(atPath: path)
    }
 
   


}




#Preview {
    GroupView(groupId: "rg", messages: [Message(sender: "fr", content: "rgrg", isFile: true)])
}
