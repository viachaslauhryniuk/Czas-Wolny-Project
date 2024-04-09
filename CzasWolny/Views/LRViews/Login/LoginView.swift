
import SwiftUI
import Pow
struct LoginView: View {
    @Environment(\.dismiss)var dismiss
    
    @ObservedObject var vm = UsersViewModel()

    @State var viewState = CGSize.zero
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            NavigationStack{
                
                VStack {
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
                    Group{
                        TextField("Wprowadz email", text: $vm.email)
                        SecureField("Wprowadź swoje hasło", text: $vm.password)
                    }
                    .padding(16)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(vm.showCodeError ? Color.red : Color("BlueAccent") , lineWidth: 2))
                    
                    .padding(.horizontal,10)
                    .padding(.bottom,15)
                    .changeEffect(.shake(rate: .fast), value: vm.shakeEffect)
                    .offset(y:-50)
                    .opacity(vm.textOpacity)
                    Button(action: {
                        vm.signInUser(completion: { status in
                            vm.verificationStatus = status
                            if vm.verificationStatus == 1 {
                                vm.showCodeError = true
                                vm.shakeEffect += 1
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    vm.showCodeError = false
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    vm.password = ""
                                }
                            }
                            else{
                                
                                vm.transfer = true
                            }
                        })})
                    {
                        Text("Login")
                            .font(.custom("FallingSkyBlk", size: 18))
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(Color("BlueAccent"))
                            .cornerRadius(15.0)
                    }
                    .offset(y:-50)
                    .opacity(vm.textOpacity)
                    .conditionalEffect(.repeat(.shine(duration: 2), every: (.seconds(4))), condition: true)
                    
                }
                                .background(
                                    Image("AnimImg")
                                        .offset(x: 140, y: -90)
                                        .opacity(vm.appearBackground ? 0.85 : 0)
                                        .offset(y: vm.appearBackground ? -10 : 0)
                                        .blur(radius: vm.appearBackground ? 0 : 40)
                                        .hueRotation(.degrees(viewState.width / 5))
                                        .scaleEffect(2)
                                )
                .background(
                                    Image("Spline")
                                        .blur(radius: 30)
                                        .offset(x: 100, y: 100)
                                        .hueRotation(.degrees(viewState.width / 2))
                                        .scaleEffect(2)
                                )
                .padding()
                .navigationBarBackButtonHidden()
                
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            vm.email = ""
                            vm.password = ""
                            vm.logoScale = 1.3
                            vm.logoOffset = 0.0
                            vm.textOpacity = 0.0
                            dismiss()
                        }) {
                            Image(systemName: "chevron.backward")
                        }
                    }
                }
            }
        
           }
        .onAppear {
                  withAnimation(.spring()) {
                      vm.appear = true
                  }
                  withAnimation(.easeOut(duration: 2)) {
                      vm.appearBackground = true
                  }
              }
        
        .fullScreenCover(isPresented: $vm.transfer) {
            MainView()
        }
        .tint(Color("BlueAccent"))
        }
    }


#Preview {
    LoginView()
}
