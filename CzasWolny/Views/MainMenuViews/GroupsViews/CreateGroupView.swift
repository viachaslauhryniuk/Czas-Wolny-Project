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
    @FocusState var showKeyboard: Bool
    var body: some View {
        NavigationStack {
            VStack {
                Section(header: Text("Nazwa grupy").foregroundColor(Color("BlueAccent"))  .font(Font.custom("FallingSkyBd", size: 18 ))) {
                    TextField("Wprowadż nazwę grupy", text: $vm.groupName)
                        .padding(16)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke( Color("BlueAccent"), lineWidth: 2))
                        .submitLabel(.done)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 15)
                }
                
                Section(header: Text("Członki grupy").foregroundColor(Color("BlueAccent"))  .font(Font.custom("FallingSkyBd", size: 18 ))) {
                    TextField("Wprowadż adres mailowy członka", text: $vm.memberEmail)
                        .padding(16)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke( Color("BlueAccent"), lineWidth: 2))
                        .submitLabel(.done)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 15)
                        .focused($showKeyboard)
                    Button {
                        // Check if the email is not the user's own and is registered
                        if !vm.memberEmail.isEmpty {
                            if vm.memberEmail != vm.creatorEmail { vm.checkIfUserExists(completion: { status in
                                vm.existingStatus = status
                                if vm.existingStatus == 1 {
                                    vm.members.append(vm.memberEmail)
                                    vm.memberEmail = ""
                                    showKeyboard = false
                                }
                            })
                            }
                        }
                    }
                label: {
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
                
                Button {
                    if vm.members == [] || vm.groupName.isEmpty {
                        
                    } else {
                        vm.createGroup()
                        
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            vm.members = []
                            vm.groupName = ""
                        }
                    }
                    
                }
            label: {
                Text("Stwórz grupę")
                    .font(.custom("FallingSkyBlk", size: 20))
                    .foregroundStyle(Color.white)
                    .padding()
                    .background(Color("BlueAccent"))
                    .cornerRadius(10)
                
            }
            }
            
            .navigationBarTitle("Tworzenie zespołu", displayMode: .inline)
          
            .navigationBarItems(leading: Button {
                dismiss()
                vm.members = []
                vm.groupName = ""
            }
                                label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color("BlueAccent"))
                
            })
            .alertX(isPresented: $vm.showAlert) {
                AlertX(title: Text("Błąd"),
                       message: Text(vm.alertMessage),
                       primaryButton: AlertX.Button.default(Text("OK"), action: {
                    vm.showAlert = false
                }), theme: AlertX.Theme.custom(windowColor: Color.white, alertTextColor: Color("BlueAccent"),
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
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    CreateGroupView()
}
