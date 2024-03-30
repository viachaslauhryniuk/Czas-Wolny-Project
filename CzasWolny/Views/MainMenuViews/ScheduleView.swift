

import SwiftUI

struct ScheduleView: View {
    var body: some View {
        
               PDFKitRepresentedView(url: Bundle.main.url(forResource: "kZ7F8D-24mar25plany", withExtension: "pdf")!)
            .ignoresSafeArea(.all, edges: .bottom)
    }
}

#Preview {
    ScheduleView()
}
