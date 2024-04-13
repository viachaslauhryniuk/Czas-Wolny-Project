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
        NavigationStack {
            VStack {

                if vm.tasks.isEmpty {
                    Text("Nie ma zadań dla twojej grupy")
                        .foregroundColor(Color.gray)
                        .font(.custom("FallingSkyBd", size: 25))
                        .padding(.horizontal, 10)
                } else {
                    List(vm.tasks) { task in

                            HStack {
                                Image(systemName: task.deadline.dateValue() < Date() ? "exclamationmark.triangle" : "timer")
                                    .imageScale(.large)
                                    .foregroundStyle(Color("BlueAccent"))
                                VStack(alignment: .leading) {
                                HStack {
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
                        }

                        .frame(width: 300, alignment: .leading)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))

                        .swipeActions(edge: .trailing) {
                                                   Button {
                                                       vm.deleteTask(task)
                                                   } label: {
                                                       Label("Zrobione", systemImage: "checkmark")
                                                   }
                                                   .labelStyle(.iconOnly)
                                                   .tint(.green)
                                               }

                    }
                    .listStyle(PlainListStyle())

                }

            }
            .onAppear {
                vm.notificationpermission()
                vm.fetchTasks()

            }
            .navigationBarTitle("Twoje Terminy", displayMode: .inline)
        }

            }

        }

#Preview {
    DeadlinesView()
        .environmentObject(ContentViewModel())
}
