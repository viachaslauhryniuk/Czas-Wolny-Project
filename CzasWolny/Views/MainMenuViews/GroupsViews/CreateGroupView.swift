//
//  CreateGroupView.swift
//  CzasWolny
//
//  Created by Слава Гринюк on 3.04.24.
//

import SwiftUI

struct CreateGroupView: View {
    @EnvironmentObject var vm: GroupViewModel
    @Environment (\.dismiss) var dismiss
    var body: some View {
        VStack {
            Section(header: Text("Group Name").foregroundColor(.blue)) {
                TextField("Enter Group Name", text: $vm.groupName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            
            Section(header: Text("Members").foregroundColor(.blue)) {
                TextField("Enter Member Email", text: $vm.memberEmail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    // Check if the email is not the user's own and is registered
                    if vm.memberEmail != vm.creatorEmail { vm.checkIfUserExists(completion: { status in
                        vm.existingStatus = status
                        if vm.existingStatus == 1{
                            vm.members.append(vm.memberEmail)
                            vm.memberEmail = ""
                        }
                    })
                        
                      
                    }
                }) {
                    Text("Add Member")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                ForEach(vm.members, id: \.self) { member in
                    Text(member)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))
                }
            }
            
            Button{
                vm.createGroup()
                vm.members = []
                vm.groupName = ""
            }
        label:{
                Text("Create Group")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                
            }
        }
        .navigationBarTitle("Create Group", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            dismiss()
            vm.members = []
            vm.groupName = ""
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.blue)
                .font(.title)
        })
    }
}

#Preview {
    CreateGroupView()
}
