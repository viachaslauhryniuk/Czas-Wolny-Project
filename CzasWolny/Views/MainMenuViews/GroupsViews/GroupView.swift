import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import UniformTypeIdentifiers
struct GroupView: View {
    @EnvironmentObject var vm: GroupViewModel
    @EnvironmentObject var vm2: ContentViewModel
    let groupId: String
    @Environment (\.dismiss) var dismiss
    @State var messages: [Message] = []
    @State var newMessage = ""
    @State private var isShowingFilePicker = false
    @State private var inputImage: URL?
    @State private var selectedFile: IdentifiableURL?
    @State var existEmoji = false
    @State var imageCount = 0
    var body: some View {

        ScrollViewReader { scrollView in
            ScrollView {
                VStack {
                    ForEach(messages, id: \.self) { message in
                        if message.isFile {
                            if let url = URL(string: message.content), url.pathExtension.lowercased() == "jpg" || url.pathExtension.lowercased() == "png" {

                                ImageMessageView(message: message, url: url, imageCount: $imageCount)
                                    .environmentObject(vm)

                            } else {
                                FileMessageView(message: message)
                                    .environmentObject(vm)
                            }
                        } else {
                            TextMessageView(message: message)
                                .environmentObject(vm)
                        }
                    }

                }
                .padding(.horizontal, 5)
                .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                loadMessages()
                                scrollView.scrollTo(messages.endIndex-imageCount, anchor: .bottom)
                            }
                        }
                        .onChange(of: messages.count) {
                            scrollView.scrollTo(messages.endIndex-imageCount, anchor: .bottom)
                        }

            }
        }

        Spacer()
        HStack(spacing: 12) {
            TextField("Nowa Wiadomość", text: $newMessage)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

            Button {
                self.isShowingFilePicker = true
            } label: {
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
                Button {
                    vm2.isChatViewActive = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        dismiss()

                    }

                } label: {
                    Image(systemName: "chevron.left")

                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitle(groupId, displayMode: .inline)
        .onDisappear(perform: {
            vm.getUserEmail()
            vm.needsRefresh = true
        })

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
                        let index = sender.firstIndex(of: "@")
                        let newSender = String(sender[..<index!])
                        let content = doc["content"] as? String ?? ""
                        let isFile = URL(string: content)?.scheme != nil
                        return Message(sender: newSender, content: content, isFile: isFile)
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
struct FileMessageView: View {
    var message: Message
    @EnvironmentObject var vm: GroupViewModel
    @State var existEmoji = false
    @State var selectedFile: IdentifiableURL?

    var body: some View {
        Button {
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
        } label: {
            if "\(message.sender)@edu.p.lodz.pl" == Auth.auth().currentUser?.email {
                Spacer()
                HStack {
                        CustomLabel(text: "File", systemImage: self.existEmoji ? "eye" : "square.and.arrow.down")
                            .foregroundStyle(Color.white)
                    }
                    .padding()
              
                    .background(ChatBubble(isFromCurrentUser: true).fill(Color("BlueAccent")))
                    
                    .foregroundColor(.white)
                    .cornerRadius(10)
             } else {
                HStack {
                  
                    VStack(alignment: .leading) {
                        
                        Text(message.sender)
                            .foregroundColor(Color.black)
                        
                            .font(.custom("FallingSkyBd", size: 12))
                        
                            .padding(.bottom, 5)
                        
                        CustomLabel(text: "File", systemImage: self.existEmoji ? "eye" : "square.and.arrow.down")
                            .foregroundStyle(Color.black)
                    }
                    
                    .padding()
                    .background(ChatBubble(isFromCurrentUser: false).fill(Color("BlueAccent2")))
                    
                    .foregroundColor(.white)
                    .cornerRadius(10)
                   
                }
                 Spacer()
            }
        }
        .sheet(item: $selectedFile) { identifiableURL in
            DocumentPreview(url: identifiableURL.url)
        }
    }
}

struct TextMessageView: View {
    var message: Message
    @EnvironmentObject var vm: GroupViewModel
    let screenW = UIScreen.main.bounds.size.width
    var body: some View {
        if "\(message.sender)@edu.p.lodz.pl" == Auth.auth().currentUser?.email {
            HStack {
                Spacer()
                Text("\(message.content)")
                    .frame(width: message.content.count > 33 ? screenW * 0.70 : message.content.count > 9 ? screenW * 0.40 : screenW * 0.20)
                    .padding()
                    .background(ChatBubble(isFromCurrentUser: true).fill(Color("BlueAccent")))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
        } else {
            HStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(message.sender)
                            .foregroundColor(Color.black)
                            .font(.custom("FallingSkyBd", size: 12))
                            .padding(.bottom, 5)
                        
                        Text(message.content)
                            .foregroundStyle(Color.black)
                    }
                    Spacer()
                 
                }
                .frame(width: message.content.count > 33 ? screenW * 0.70 : message.content.count > 9 ? screenW * 0.40 : screenW * 0.20)
                .padding()
                .background(ChatBubble(isFromCurrentUser: false).fill(Color("BlueAccent2")))
                .foregroundColor(.white)
                .cornerRadius(10)
                Spacer()
            }
        }
    }
}

struct ImageMessageView: View {
    var message: Message
    var url: URL
    @EnvironmentObject var vm: GroupViewModel
    @Binding var imageCount: Int
    var body: some View {
        if "\(message.sender)@edu.p.lodz.pl" == Auth.auth().currentUser?.email {

            HStack {
                Spacer()
                VStack {

                    AsyncImage(url: url) { image in
                        image.resizable()
                            .frame(width: UIScreen.main.bounds.size.width * 0.55, height: UIScreen.main.bounds.size.height * 0.33)
                            .scaledToFit()
                    } placeholder: {
                        ZStack {
                            Color.gray
                                .frame(width: UIScreen.main.bounds.size.width * 0.55, height: UIScreen.main.bounds.size.height * 0.33)
                            Image(systemName: "photo")
                        }
                    }
                    .onAppear(perform: {
                      imageCount += 1
                    })
                    .background(ChatBubble(isFromCurrentUser: true).fill(Color("BlueAccent")))
                }
                .padding()
                .background(ChatBubble(isFromCurrentUser: true).fill(Color("BlueAccent")))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        } else {
            HStack {
                VStack(alignment: .leading) {
                    HStack {

                                                       Text(message.sender)
                            .foregroundColor(Color.black)
                                .font(.custom("FallingSkyBd", size: 12))

                        Spacer()
                    }
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width * 0.7)
                    } placeholder: {
                        ZStack {
                            Color.gray
                                .frame(width: UIScreen.main.bounds.size.width * 0.55, height: UIScreen.main.bounds.size.height * 0.33)
                            Image(systemName: "photo")
                        }
                    }
                }
                .frame(maxWidth: UIScreen.main.bounds.width * 0.7)
                .padding()
                .background(ChatBubble(isFromCurrentUser: false).fill(Color("BlueAccent2")))
                .foregroundColor(.white)
                .cornerRadius(10)
                Spacer()
            }
        }
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
