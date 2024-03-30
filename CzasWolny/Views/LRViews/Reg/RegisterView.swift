import SwiftUI
import AlertX
import Combine

// This is your main view for registration.
struct RegisterView: View {
    // This is your ViewModel which you're using to manage your state.
    @Environment(\.dismiss)var dismiss
    @EnvironmentObject var vm : UsersViewModel
    @State var cancellable: AnyCancellable?
    
    var body: some View {
        NavigationStack {
            VStack {
                // This is your logo image.
                Image("Book")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(vm.logoScale)
                    .offset(y: vm.logoOffset)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 2.0)) {
                            vm.logoScale = 0.9
                            vm.logoOffset = -80
                        }
                        withAnimation(.easeInOut(duration: 2.0).delay(2.0)) {
                            vm.textOpacity = 1.0
                        }
                    }
                
                // This is your instruction text.
                Group {
                    Text("Wprowadz adres mailowy \n z koncowka")
                        .font(Font.custom("FallingSkyBd", size: 30 ))
                        .foregroundStyle(Color.black)
                        .opacity(vm.verifiCode ? 0 : 1)
                    Text("p.lodz.pl")
                        .font(Font.custom("FallingSkyBd", size: 35 ))
                        .foregroundStyle(Color("BlueAccent"))
                }
                .multilineTextAlignment(.center)
                .opacity(vm.textOpacity)
                .offset(y:-50)
                
                // This is your email input field.
                TextField("", text: $vm.email) { isEditing in
                    vm.isEditing = isEditing
                } onCommit: {
                    print("onCommit")
                }
                .padding(16)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(vm.isEditing ? Color("BlueAccent") : Color.black, lineWidth: 2))
                .animation(.easeInOut, value: vm.isEditing)
                .padding(.horizontal,20)
                .offset(y:-50)
                .opacity(vm.textOpacity)
                
                // This is your button for submitting the form.
                Button {
                    vm.isLoading = true
                    if !vm.isValidEmail(vm.email){
                        vm.errorMessage = "Wprowadzony adres email jest nieprawidłowy lub nie należy do 'edu.p.lodz.pl'"
                        vm.errorShow = true
                        vm.isLoading = false
                    }
                    else{
                        vm.checkIfUserExists(completion: { status in
                            vm.existingStatus = status
                            if vm.existingStatus == 1{
                                vm.errorMessage = "Konto już istnieje"
                                vm.errorShow = true
                                vm.isLoading = false
                                vm.email = ""
                            }
                            else{
                                // Only start the URLSession data task if no error has been shown
                                if !vm.errorShow {
                                    let url = URL(string: "https://api.hunter.io/v2/email-verifier?email=\(vm.email)&api_key=5fcbeee2f1413e6ba1f0d979c71be8a35a81e4db")!
                                    cancellable = URLSession.shared.dataTaskPublisher(for: url)
                                        .map { $0.data }
                                        .decode(type: ApiResponse.self, decoder: JSONDecoder())
                                        .receive(on: DispatchQueue.main)
                                        .sink(receiveCompletion: { _ in }, receiveValue: { response in
                                            if response.data.status != "valid" {
                                                vm.errorMessage = "Wprowadzony adres email\n nie istnieje w ramach 'edu.p.lodz.pl'"
                                                vm.errorShow = true
                                                vm.isLoading = false
                                            }
                                            else {
                                                vm.verifiCode = true
                                                vm.isLoading = false
                                            }
                                        })
                                }
                            }
                        })
                    }

                    }
                
            label: {
                Label("Done", systemImage: vm.isLoading ? "hourglass" : "arrowshape.right")
                    .labelStyle(.iconOnly)
                    .font(.system(size: 27 , weight: .bold))
                    .foregroundStyle(Color.white)
            }
            .frame(width: 100, height: 60)
            .background(Color("BlueAccent"))
            .clipShape(.rect(cornerRadius: 15))
            .padding(.bottom,5)
            .opacity(vm.textOpacity)
            .alertX(isPresented: $vm.errorShow, content: {
                AlertX(title: Text("Błąd"),message:Text (vm.errorMessage),theme: AlertX.Theme.custom(windowColor: Color.white,
                                                                                                                                                                    alertTextColor: Color("BlueAccent"),
                                                                                                                                                                    enableShadow: true,
                                                                                                                                                                    enableRoundedCorners: true,
                                                                                                                                                                    enableTransparency: false,
                                                                                                                                                                    cancelButtonColor: Color("BlueAccent2"),
                                                                                                                                                                    cancelButtonTextColor: Color.white,
                                                                                                                                                                    defaultButtonColor: Color("BlueAccent2"),
                                                                                                                                                                    defaultButtonTextColor: Color("BlueAccent"),
                                                                                                                                                                    roundedCornerRadius: 20),
                       animation: .classicEffect()
                )
            })

            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        vm.email = ""
                        vm.logoScale = 1.3
                        vm.logoOffset = 0.0
                        vm.textOpacity = 0.0
                        dismiss()
                    })
                    {
                        Image(systemName: "chevron.left")
                    }
                }
            }
        }
        .tint(Color("BlueAccent"))
        .sheet(isPresented: $vm.verifiCode) {
            EmailConfirmationView()
                .presentationDetents([.fraction(0.4)])
                .environmentObject(vm)
        }
    }
}

#Preview {
    RegisterView()
}
