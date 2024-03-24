import SwiftUI

// This is your main view for creating a password.
struct PasswordMakeView: View {
    // This is your ViewModel which you're using to manage your state.
    @EnvironmentObject var vm: UsersViewModel

    var body: some View {
            // This VStack contains all your content.
            VStack {
                // This is your title.
                Text("Wymyśl Hasło")
                    .font(.custom("FallingSkyBd", size: 35))
                    .foregroundStyle(Color("BlueAccent"))
                    .padding(20)
                
                // This VStack contains your password tips.
                VStack(alignment: .center, spacing: 20) {
                    Text("Oto kilka wskazówek, które pomogą Ci stworzyć silne hasło:")
                        .font(.custom("FallingSkyBd", size: 27))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // This conditionally shows your password tips when showTips is true.
                    if vm.showTips {
                        ScrollView {
                            VStack(spacing: 20) {
                                Text("Długość hasła: Twoje hasło powinno mieć co najmniej 12 znaków. Im dłuższe hasło, tym trudniej je złamać.")
                                    .font(.custom("FallingSkyBd", size: 20))
                                

                                Text("Różnorodność znaków: Używaj różnych typów znaków, takich jak małe litery, wielkie litery, cyfry i znaki specjalne (np. @, #, $, %, ^, &, *).")
                                    .font(.custom("FallingSkyBd", size: 20))

                                Text("Unikaj oczywistości: Nie używaj łatwych do odgadnięcia haseł, takich jak “password”, “123456”, czy też Twojego imienia, nazwiska, daty urodzenia czy adresu.")
                                    .font(.custom("FallingSkyBd", size: 20))

                            }
                            .multilineTextAlignment(.center)
                            .padding()
                        }
                    }
                    
                    // This is your button for toggling the visibility of the password tips.
                    HStack{
                        Button(action: {
                            withAnimation {
                                vm.showTips.toggle()
                            }
                        })
                        {
                            Image(systemName: vm.showTips ? "chevron.up" : "chevron.down")
                                .scaleEffect(2)
                                .foregroundStyle(Color("BlueAccent"))
                        }
                    }
                    .padding()
                }
                
                // This VStack contains your password and confirm password fields.
                VStack(alignment: .leading) {
                    Text("Hasło")
                        .font(.custom("FallingSkyBd", size: 20))
                        .padding(.horizontal,20)
                    SecureField("Wprowadź swoje hasło", text: $vm.password)
                        .padding(16)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("BlueAccent") , lineWidth: 2))
                        .padding(.horizontal,20)
                        .padding(.bottom,15)

                    Text("Potwierdź Hasło")
                        .font(.custom("FallingSkyBd", size: 20))
                        .padding(.horizontal,20)
                    SecureField("Potwierdź swoje hasło", text: $vm.confirmPassword)
                        .padding(16)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("BlueAccent") , lineWidth: 2))
                        .padding(.horizontal,20)
                        .padding(.bottom,25)
                }
                .padding(.horizontal, 20)
                
                // This is your button for submitting the form.
                Button {
                    // TODO: Handle password creation here
                } label: {
                    Text("Załóż Konto")
                        .font(.custom("FallingSkyBd", size: 20))
                        .foregroundStyle(Color.white)
                }
                .frame(width: 300)
                .frame(height: 50)
                .background(Color("BlueAccent"))
                .clipShape(.rect(cornerRadius: 15))
                .padding(.bottom,5)
                .padding(.horizontal, 20)
                
               
            }
            .padding(.top, 20)
            .opacity(vm.opacity)
            .onAppear {
                // This animation fades in your content when the view appears.
                withAnimation(.easeIn(duration: 1.5)) {
                    vm.opacity = 1
                }
            }
        }
    
}

struct PasswordMakeView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordMakeView()
    }
}
