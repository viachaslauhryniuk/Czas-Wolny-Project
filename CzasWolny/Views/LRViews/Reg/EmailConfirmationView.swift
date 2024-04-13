import SwiftUI
import Pow

// This is your main view for email confirmation.
struct EmailConfirmationView: View {
    // This is your ViewModel which you're using to manage your state.
    @EnvironmentObject var vm: UsersViewModel
    @FocusState private var focusedField: Int?
    @FocusState private var focusItem: Bool
    @Environment (\.dismiss) var dismiss

    var body: some View {
        ZStack {
            VStack {
                // This is your background gradient.
                LinearGradient(gradient: Gradient(colors: [Color("Gray2"), Color.white]), startPoint: .top, endPoint: .bottom)
            }
            .ignoresSafeArea(edges: .all)

            VStack {
                // This is your instruction text.
                Text("Wyslalismy kod weryfikacyjny na podany przez ciebie adres e-mail. Pamiętaj, że kod ten jest ważny tylko przez 15 minut.")
                    .font(Font.custom("FallingSkyBd", size: 20 ))
                    .foregroundStyle(Color.black)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 15)
                    .padding(.horizontal, 15)

                // This HStack contains your text fields for entering the verification code.
                HStack {
                    ForEach(0..<6) { index in
                        TextField("", text: $vm.enteredCode[index])
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(vm.showCodeError ? Color.red : Color("BlueAccent"), lineWidth: 2)
                            )
                            .keyboardType(.numberPad)
                            .focused($focusItem)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 40, height: 40)
                            .multilineTextAlignment(.center)
                            .focused($focusedField, equals: index)
                            .onChange(of: vm.enteredCode[index]) { _, newValue in
                                vm.enteredCode[index] = String(newValue.prefix(1))
                                if newValue.isEmpty {
                                    // If the field is empty, move to the previous field.
                                    if index > 0 {
                                        focusedField = index - 1
                                    }
                                } else {
                                    // If the field is not empty, move to the next field.
                                    if index < 5 {
                                        focusedField = index + 1
                                    }
                                }
                                vm.lastEditedField = index
                            }
                            .changeEffect(.shake(rate: .fast), value: vm.shakeEffect)
                    }
                }
                .padding(.bottom, 55)

                // This is your button for submitting the form.
                Button {
                    focusItem = false
                    vm.checkVerificationCode { status in
                        vm.verificationStatus = status
                        if vm.verificationStatus == 1 {
                            vm.showCodeError = true
                            vm.shakeEffect += 1
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                vm.showCodeError = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    vm.enteredCode = Array(repeating: "", count: 6)
                                    vm.lastEditedField = nil
                                    focusedField = nil
                                }
                            }
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                vm.makePass = true
                            }
                        }
                    }
                } label: {
                    Label("ber", systemImage: "checkmark")
                        .labelStyle(.iconOnly)
                        .font(.system(size: 27, weight: .bold))
                        .foregroundStyle(Color.white)
                }
                .frame(width: 80, height: 50)
                .background(Color("BlueAccent"))
                .clipShape(.rect(cornerRadius: 10))
                .padding(.bottom, 5)
            }
        }
        .onAppear(perform: {
            vm.sendEmail()
        })
        .fullScreenCover(isPresented: $vm.makePass) {
            PasswordMakeView()
                .environmentObject(vm)

        }
    }
}

struct EmailConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        EmailConfirmationView()
    }
}
