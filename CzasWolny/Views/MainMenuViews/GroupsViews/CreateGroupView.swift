//
//  CreateGroupView.swift
//  CzasWolny
//
//  Created by Слава Гринюк on 3.04.24.
//

import SwiftUI
import AlertX
struct CreateGroupView: View {
    @EnvironmentObject var vm: GroupViewModel
    @Environment (\.dismiss) var dismiss
    var body: some View {
        VStack {
            Section(header: Text("Nazwa grupy").foregroundColor(Color("BlueAccent"))  .font(Font.custom("FallingSkyBd", size: 18 ))) {
                TextField("Wprowadż nazwę grupy", text: $vm.groupName)
                    .padding(16)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke( Color("BlueAccent") , lineWidth: 2))
                    
                    .padding(.horizontal,10)
                    .padding(.bottom,15)
            }
            
            Section(header: Text("Członki grupy").foregroundColor(Color("BlueAccent"))  .font(Font.custom("FallingSkyBd", size: 18 ))) {
                TextField("Wprowadż adres mailowy członka", text: $vm.memberEmail)
                    .padding(16)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke( Color("BlueAccent") , lineWidth: 2))
                    
                    .padding(.horizontal,10)
                    .padding(.bottom,15)
                
                Button(action: {
                    // Check if the email is not the user's own and is registered
                    if !vm.memberEmail.isEmpty{
                        if vm.memberEmail != vm.creatorEmail { vm.checkIfUserExists(completion: { status in
                            vm.existingStatus = status
                            if vm.existingStatus != 1{
                                vm.alertMessage = "Ten student nie ma jeszcze konta tutaj"
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                                    vm.showAlert = true
                                }
                            }
                            else{
                                vm.members.append(vm.memberEmail)
                                vm.memberEmail = ""
                            }
                        })
                        }
                    }
                }) {
                    Text("Dodaj członka")
                        .font(.custom("FallingSkyBlk", size: 20))
                        .foregroundStyle(Color.white)
                        .padding()
                        .background(Color("BlueAccent"))
                        .cornerRadius(10)
                }

                
                ForEach(vm.members, id: \.self) { member in
                    Text(member)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("BlueAccent"), lineWidth: 2))
                }
            }
            
            Button{
                if vm.members == []{
                    vm.alertMessage = "Grupa nie może być pusta"
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                        vm.showAlert = true
                    }
                }
                else{
                    vm.createGroup()
                    dismiss()
                }
                vm.members = []
                vm.groupName = ""
            }
        label:{
                Text("Stwórz grupę")
                .font(.custom("FallingSkyBlk", size: 20))
                .foregroundStyle(Color.white)
                    .padding()
                    .background(Color("BlueAccent"))
                    .cornerRadius(10)
                
            }
        }
        .navigationBarTitle("Tworzenie zespołu", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            dismiss()
            vm.members = []
            vm.groupName = ""
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(Color("BlueAccent"))
                .font(.title)
        })
        .alertX(isPresented: $vm.showAlert) {
            AlertX(title: Text("Błąd"),message:Text(vm.alertMessage),theme: AlertX.Theme.custom(windowColor: Color.white,
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
        }
    }
}

#Preview {
    CreateGroupView()
}
