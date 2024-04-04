

import SwiftUI

struct ScheduleView: View {
    let scheduleLoader = ScheduleLoader()
    @EnvironmentObject var vm: ContentViewModel
    var body: some View {
        VStack{
            
            Text("Twój rozkład zajęć")
                .font(.custom("FallingSkyBd", size: 30))
                .foregroundStyle(Color("BlueAccent"))     
            Divider()
                
            Spacer()
            if let url = scheduleLoader.getUrl(forGroup: vm.selectedGroup) {
                ImageView(url: url)
            } else {
                Text("No schedule available for this group.")
            }
            Spacer()
        }
    }
    }


#Preview {
    ScheduleView()
}
