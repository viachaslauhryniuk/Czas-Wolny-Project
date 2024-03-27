
import SwiftUI
import Pow
struct LoginView: View {
    @Environment(\.dismiss)var dismiss
    
    @EnvironmentObject var vm : UsersViewModel
    var body: some View {
        NavigationStack{
               VStack {
                   Group{
                       TextField("Wprowadz email", text: $vm.email)
                       SecureField("Wprowadź swoje hasło", text: $vm.password)
                   }
                   .padding(16)
                   .overlay(RoundedRectangle(cornerRadius: 10).stroke(vm.showCodeError ? Color.red : Color("BlueAccent") , lineWidth: 2))

                   .padding(.horizontal,10)
                   .padding(.bottom,15)
                   .changeEffect(.shake(rate: .fast), value: vm.shakeEffect)
                      
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
                   .conditionalEffect(.repeat(.shine(duration: 2), every: (.seconds(4))), condition: true)
                   
               }
               .padding()
               .navigationBarBackButtonHidden()
               .toolbar {
                   ToolbarItem(placement: .topBarLeading) {
                       Button(action: {
                           vm.email = ""
                           vm.password = ""
                           dismiss()
                       }) {
                           Image(systemName: "chevron.backward")
                       }
                   }
               }
               .navigationBarTitle("Login", displayMode: .inline)
           }
        .opacity(vm.opacity)
        .onAppear {
            // This animation fades in your content when the view appears.
            withAnimation(.easeIn(duration: 1.5)) {
                vm.opacity = 1
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
