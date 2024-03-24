//
//  PasswordMakeVieqw.swift
//  CzasWolny
//
//  Created by Слава Гринюк on 20.03.24.
//
import SwiftUI

struct PasswordMakeView: View {
    @State private var opacity: Double = 0
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        VStack {
            Image("Logo2")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.50)
                .clipped()
            
            Text("Wymyśl Hasło")
                .font(.custom("FallingSkyBlk", size: 35))
                .foregroundStyle(Color.black)
                .padding(20)
            
            VStack(alignment: .leading) {
                Text("Hasło")
                    .font(.custom("FallingSkyBlk", size: 20))
                    .padding(.horizontal,20)
                SecureField("Wprowadź swoje hasło", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                  
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("BlueAccent"), lineWidth: 2))
                    .padding(.bottom, 10)
                    .padding(.horizontal,20)
              
                   
                
                Text("Potwierdź Hasło")
                
                    .font(.custom("FallingSkyBlk", size: 20))
                
                
                    .padding(.horizontal,20)
                SecureField("Potwierdź swoje hasło", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("BlueAccent"), lineWidth: 2))
                    .padding(.bottom, 20)
                    .padding(.horizontal,20)
                
            }
            .padding(.horizontal, 20)
            
            Button {
                // Handle password creation here
            } label: {
                Text("Załóż Konto")
                    .font(.custom("FallingSkyBd", size: 27))
                    .foregroundStyle(Color.white)
            }
            .frame(width: 200)
            .frame(height: 50)
            .background(Color("BlueAccent"))
            .clipShape(.rect(cornerRadius: 15))
            .padding(.bottom,5)
            
            .padding(.horizontal, 20)
            
            Spacer() // Pushes the content to the top, removing empty space
        }
        .padding(.top, 20)
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeIn(duration: 1.5)) {
                opacity = 1
            }
        }
    }
}

#Preview {
    PasswordMakeView()
}
