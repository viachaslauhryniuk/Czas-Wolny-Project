//
//  MainView.swift
//  CzasWolny
//
//  Created by Слава Гринюк on 27.03.24.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var vm = ContentViewModel()
    @Namespace private var animation
    var body: some View {
        VStack {
            Spacer()
            getView(for: vm.activeTab)
           Spacer()
            CustomTabbar()
        }
    }
    @ViewBuilder
    func CustomTabbar(_ tint:Color = Color("BlueAccent"), _ inactiveTint:Color = .gray) -> some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { item in
                TabItemView(tint: tint, inactiveTint: inactiveTint, tab: item, animation: animation, activeTab: $vm.activeTab)
            }
        }
        .padding(.horizontal,15)
        .padding(.vertical, 10)
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.7), value: vm.activeTab)
        .background{
            Rectangle()
                .fill(.white)
                .ignoresSafeArea()
                .shadow(color: tint.opacity(0.2), radius: 5, x: 0, y: -5)
                .padding(.top,25)
        }
    }
    @ViewBuilder
    func getView(for tab: Tab) -> some View {
        switch tab {
        case .deadlines:
            if vm.selectedGroup.isEmpty {
                GroupChoiceView().environmentObject(vm)
            }
            else{
                DeadlinesView()
                    .environmentObject(vm)
            }
        case .groups:
            
                GroupsView()
        case .schedule:
            if vm.selectedGroup.isEmpty {
                GroupChoiceView().environmentObject(vm)
                    
            }
            else{
                ScheduleView()
                    .environmentObject(vm)
            }
        }
    }
    
}

#Preview {
    MainView(vm: ContentViewModel())
}
