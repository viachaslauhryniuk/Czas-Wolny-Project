//
//  ContentView.swift
//  CzasWolny
//
//  Created by Слава Гринюк on 14.03.24.
//

import SwiftUI

struct EnterView: View {
    @ObservedObject var vm = EnterViewModel()

    var body: some View {

    NavigationStack {
            VStack {
                Image("Logo1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.55)
                    .clipped()
                    .padding(.bottom)

                VStack {
                    Text("Jestes Studentem Politechniki Lodzkiej?")
                        .font(Font.custom("FallingSkyBd", size: 18 ))

                    Text("Zaloż konto już dziś!")
                        .font(.custom("FallingSkyBd", size: 30))
                        .foregroundStyle(Color("BlueAccent"))
                }
                .padding(.bottom, 25)

                Button {
                    vm.nextView = .registration
                    vm.showLogRegView.toggle()
                } label: {
                    Text("Start")
                        .font(.custom("FallingSkyBlk", size: 27))
                        .foregroundStyle(Color.white)
                }
                .frame(width: 200, height: 60)
                .background(Color("BlueAccent"))
                .clipShape(.rect(cornerRadius: 15))
                .padding(.bottom, 5)

                Button {
                    vm.nextView = .login
                    vm.showLogRegView.toggle()
                } label: {
                    Text("Juz masz konto?")
                        .font(Font.custom("FallingSkyBd", size: 15))
                        .foregroundStyle(Color.black)
                }

            }
            .padding()
            .navigationDestination(isPresented: $vm.showLogRegView) {
                switch vm.nextView {
                case .login:
                    LoginView().environmentObject(vm)
                case .registration:
                    RegisterView().environmentObject(vm)
                }

            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    EnterView()
}
