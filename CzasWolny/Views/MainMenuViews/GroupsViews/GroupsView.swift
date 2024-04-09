//
//  GroupsView.swift
//  CzasWolny
//
//  Created by Слава Гринюк on 3.04.24.
//

import SwiftUI
import FirebaseAuth
struct GroupsView: View {
    @ObservedObject var vm = GroupViewModel()
    @State private var isLoggedOut = false

    var body: some View {
        NavigationView {
            ZStack {
                // Set the background to white
                Color.white.edgesIgnoringSafeArea(.all)
                
                // Display the list or the 'no groups' message
                if vm.groups.isEmpty {
                    Text("Nie masz chatów")
                        .foregroundColor(Color.gray)
                        .font(.custom("FallingSkyBd", size: 25))
                } else {
                    List(vm.groups, id: \.self) { group in
                        NavigationLink(destination: GroupView(groupId: group).environmentObject(vm)) {
                            Text(group)
                                .padding()
                                
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .onAppear(perform: vm.loadGroups)
            .navigationBarTitle("Twoje Chaty", displayMode: .inline)
            .navigationBarItems(leading:  Button(action: {
                if !isLoggedOut{
                    do {
                        try Auth.auth().signOut()
                        self.isLoggedOut = true
                    } catch let signOutError as NSError {
                        print("Error signing out: %@", signOutError)
                    }
                }
                else{}}) {
                Image(systemName: "arrowshape.turn.up.left")
            }, trailing: NavigationLink(destination: CreateGroupView().environmentObject(vm)) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(Color("BlueAccent"))
                    .font(.title)
            })
        }
        .onAppear(perform: {
            vm.getUserEmail()
        })
        .fullScreenCover(isPresented: $isLoggedOut) {
            EnterView()
        }
    }
}



#Preview {
    GroupsView()
}
