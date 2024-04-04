//
//  GroupsView.swift
//  CzasWolny
//
//  Created by Слава Гринюк on 3.04.24.
//

import SwiftUI

struct GroupsView: View {
    @ObservedObject var vm = GroupViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                // Set the background to white
                Color.white.edgesIgnoringSafeArea(.all)
                
                // Display the list or the 'no groups' message
                if vm.groups.isEmpty {
                    Text("Nie masz chatów")
                        .foregroundColor(Color("BlueAccent"))
                        .font(.title)
                } else {
                    List(vm.groups, id: \.self) { group in
                        NavigationLink(destination: GroupView(groupId: group).environmentObject(vm)) {
                            Text(group)
                                .padding()
                                
                        }
                    }
                }
            }
            .onAppear(perform: vm.loadGroups)
            .navigationBarTitle("Twoje Chaty", displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink(destination: CreateGroupView().environmentObject(vm)) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(Color("BlueAccent"))
                    .font(.title)
            })
        }
        .onAppear(perform: {
            vm.getUserEmail()
        })
    }
}



#Preview {
    GroupsView()
}
