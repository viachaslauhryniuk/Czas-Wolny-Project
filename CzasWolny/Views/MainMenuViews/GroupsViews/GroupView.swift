import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import UniformTypeIdentifiers
struct GroupView: View {
    @EnvironmentObject var vm: GroupViewModel
    let groupId: String
    @Environment (\.dismiss) var dismiss
    @State var messages: [Message] = []
    @State var newMessage = ""
    @State private var isShowingFilePicker = false
    @State private var inputImage: URL?
    @State private var selectedFile: IdentifiableURL? = nil
    @State var existEmoji = false
    var body: some View {
        
        ScrollViewReader { scrollView in
            ScrollView {
                VStack {
                    ForEach(messages, id: \.self) { message in
                        if message.isFile {
                            if let url = URL(string: message.content), url.pathExtension.lowercased() == "jpg" || url.pathExtension.lowercased() == "png" {
                                if message.sender == Auth.auth().currentUser?.email {
                                    HStack {
                                        Spacer()
                                        
                                        VStack{
                                           
                                            AsyncImage(url: url) { image in
                                                image.resizable()
                                                    .frame(width: UIScreen.main.bounds.size.width * 0.55, height: UIScreen.main.bounds.size.height * 0.33)
                                                    .scaledToFit()
                                    
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .background(ChatBubble(isFromCurrentUser: true).fill(Color("BlueAccent")))
                                        }
                                        
                                        .padding()
                                        .background(ChatBubble(isFromCurrentUser: true).fill(Color("BlueAccent")))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                    }
                                } else {
                                     HStack {
                                        VStack(alignment: .leading){
                                            HStack{
                                                Text(message.sender)
                                                    .font(.custom("FallingSkyBd", size: 12))
                                                Spacer()
                                            }
                                            AsyncImage(url: url) { image in
                                                image.resizable()
                                                    .scaledToFit()
                                                    .frame(width: UIScreen.main.bounds.width * 0.7)
                                                    
                                            } placeholder: {
                                                ProgressView()
                                            }
                                        }
                                        .frame(maxWidth: UIScreen.main.bounds.width * 0.7)
                                        .padding()
                                        .background(ChatBubble(isFromCurrentUser: false).fill(Color.gray))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        Spacer()
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
                                    if message.sender == Auth.auth().currentUser?.email {
                                        HStack {
                                            Spacer()
                                           
                                            VStack{
                                                
                                                  
                                                
                                                CustomLabel(text: "File", systemImage: self.existEmoji ? "eye" : "square.and.arrow.down")
                                                
                                                
                                                    
                                            }
                                            .padding()
                                            .background(ChatBubble(isFromCurrentUser: true).fill(Color("BlueAccent")))
                                        
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                        }
                                    } else {
                                        HStack {
                                            VStack(alignment: .leading){
                                                Text(message.sender)
                                                    .font(.custom("FallingSkyBd", size: 12))
                                                    .padding(.bottom,5)
                                                
                                                CustomLabel(text: "File", systemImage: self.existEmoji ? "eye" : "square.and.arrow.down")
                                            }
                                                .padding()
                                                .background(ChatBubble(isFromCurrentUser: false).fill(Color.gray))
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                            
                                            Spacer()
                                        }
                                    }
                                    
                                }
                                .sheet(item: $selectedFile) { identifiableURL in
                                    DocumentPreview(url: identifiableURL.url)
                                }
                                
                            }
                        } else {
                            if message.sender == Auth.auth().currentUser?.email {
                                HStack {
                                    Spacer()
                                    
                                    Text("\(message.content)")
                                        .padding()
                                        .background(ChatBubble(isFromCurrentUser: true).fill(Color("BlueAccent")))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            } else {
                                HStack {
                                    VStack(alignment: .leading){
                                    Text(message.sender)
                                            .font(.custom("FallingSkyBd", size: 12))
                                            .padding(.bottom,5)
                                    Text(message.content)
                                        
                                    
                                }
                                    .padding()
                                    .background(ChatBubble(isFromCurrentUser: false).fill(Color.gray))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                Spacer()
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal,5)
                .onChange(of: messages.count) { _ in
                    scrollView.scrollTo(messages.last, anchor: .bottom)
                }
                .onAppear(perform: loadMessages)
            }
        }
        Spacer()
        HStack(spacing: 12) {
            TextField("Nowa Wiadomość", text: $newMessage)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            
            Button(action: {
                self.isShowingFilePicker = true
            }) {
                Image(systemName: "square.and.arrow.up.fill")
                    .imageScale(.large)
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
            Button(action: sendMessage) {
                Image(systemName: "paperplane.fill")
                    .imageScale(.large)
            }
            .disabled(newMessage.isEmpty)
        }
        .padding(.horizontal)
        
        
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                })
                {
                    Image(systemName: "chevron.left")
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitle(groupId, displayMode: .inline)
        
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
struct CustomLabel: View {
    var text: String
    var systemImage: String
    
    var body: some View {
        HStack {
            Text(text)
            Image(systemName: systemImage)
        }
    }
}




#Preview {
    GroupView(groupId: "rg", messages: [Message(sender: "fr", content: "rgrg", isFile: true)])
}
