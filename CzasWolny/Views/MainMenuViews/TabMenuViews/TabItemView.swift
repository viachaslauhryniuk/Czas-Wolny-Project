import SwiftUI

struct TabItemView: View {
    var tint: Color
    var inactiveTint: Color
    var tab: Tab
    var animation: Namespace.ID

    @Binding var activeTab: Tab

    var body: some View {
           VStack {
               Image(systemName: tab.systemImage)
                   .font(.title2)
                   .foregroundColor(activeTab == tab ? .white : inactiveTint)
                   .frame(width: activeTab == tab ? 55 : 37, height: activeTab == tab ? 55 : 37) // Reduced from 58/35 to 48/30
                   .background {
                       if activeTab == tab {
                           Circle().fill(tint.gradient)
                               .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                       }
                   }
               Text(tab.rawValue)
                   .font(.caption)
                   .foregroundColor(activeTab == tab ? tint : inactiveTint)
           }
           .frame(maxWidth: .infinity)
           .contentShape(Rectangle())

           .onTapGesture {
               activeTab = tab
           }
       }}

#Preview {
    MainView()
}
