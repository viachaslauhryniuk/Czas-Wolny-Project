

import SwiftUI

struct ScheduleView: View {
    let scheduleLoader = ScheduleLoader()
    @EnvironmentObject var vm: ContentViewModel
    var body: some View {
        
        if let url = scheduleLoader.getUrl(forGroup: vm.selectedGroup) {
                    ImageView(url: url)
                } else {
                    Text("No schedule available for this group.")
                }
            }
      
    }


#Preview {
    ScheduleView()
}
