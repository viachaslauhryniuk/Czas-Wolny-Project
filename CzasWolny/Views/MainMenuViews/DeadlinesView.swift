//
//  DeadlinesView.swift
//  CzasWolny
//
//  Created by Слава Гринюк on 1.04.24.
//

import SwiftUI

struct DeadlinesView: View {
    @EnvironmentObject var vm: ContentViewModel
    var body: some View {
        NavigationStack{
            VStack {
                
                Text("Twoje terminy")
                    .font(.custom("FallingSkyBd", size: 30))
                    .foregroundStyle(Color("BlueAccent"))                       
                Divider()
                Spacer()
                if vm.tasks.isEmpty {
                    Text("Nie ma zadań dla twojej grupy")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding(.horizontal,10)
                } else {
                    List(vm.tasks) { task in
                        VStack(alignment: .leading) {
                            HStack{
                                Text(task.title)
                                    .font(.custom("FallingSkyBd", size: 23))
                                    .foregroundStyle(Color("BlueAccent"))
                                if task.deadline.dateValue() < Date() {
                                    Text("zaległe")
                                        .font(.caption2)
                                        .foregroundColor(.white)
                                        .padding(5)
                                        .background(Color.red)
                                        .cornerRadius(5)
                                }
                            }
                            Text(task.description)
                                .font(Font.custom("FallingSkyBd", size: 18 ))
                            Text("Termin: \(vm.formatDate(task.deadline.dateValue()))")
                                .font(Font.custom("FallingSkyBd", size: 12 ))
                        }
                        .frame(width: 300, alignment: .leading)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("BlueAccent"), lineWidth: 2))
                        .contextMenu {
                            Button(action: {
                                vm.deleteTask(task)
                            }) {
                                Label("Usuń", systemImage: "trash")
                            }
                        }
                        
                    }
                    .listStyle(PlainListStyle())
                    
                }
                Spacer()
            }
            .onAppear {
                vm.notificationpermission()
                vm.fetchTasks()
                
            }
        }
       
        
            }

          
        }


#Preview {
    DeadlinesView()
        .environmentObject(ContentViewModel())
}
