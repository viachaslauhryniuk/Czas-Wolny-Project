//
//  LoginView.swift
//  CzasWolny
//
//  Created by Слава Гринюк on 14.03.24.
//
//TODO: login view
import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss)var dismiss
    @EnvironmentObject var vm : UsersViewModel
    var body: some View {
        NavigationStack{
            VStack{
                
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                    }
                }
            }
            
        }
        .tint(Color("BlueAccent"))
        //        Text("Welcome back!")
        //            .foregroundStyle(.red)
        //            .font(.system(size: 30, weight: .bold))
        //            .padding(.bottom,25)
        //        Group{
        //            //TextField("Username", text: $UserName)
        //           // SecureField("Password", text: $Password)
        //        }
        //
        //        .padding()
        //        .clipShape(.rect(cornerRadius: 12))
        //        .background(
        //                RoundedRectangle(cornerRadius: 12)
        //                    .stroke(Color.red)
        //            )
        //        .padding(.horizontal)
        //
        //        Button(role: .destructive){
        //
        //        } label: {
        //            Text("Sign in")
        //                .font(.system(size: 22 , weight: .semibold))
        //                .foregroundStyle(.white)
        //        }
        //        .frame(width: 220, height: 60)
        //        .background(Color(.red))
        //        .clipShape(.rect(cornerRadius: 15))
        //
        //    }
        //    }
    }
}

#Preview {
    LoginView()
}
