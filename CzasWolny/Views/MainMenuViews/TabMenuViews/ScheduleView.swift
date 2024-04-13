import SwiftUI

struct ScheduleView: View {
    let scheduleLoader = ScheduleLoader()
    @EnvironmentObject var vm: ContentViewModel
    var body: some View {
        NavigationStack {
            VStack {

                if let url = scheduleLoader.getUrl(forGroup: vm.selectedGroup) {
                    ImageView(url: url)
                } else {
                    Text("No schedule available for this group.")
                }

            }
            .navigationBarTitle("Twój Rozkład zajęć", displayMode: .inline)

        }
    }
    }

#Preview {
    ScheduleView()
}
