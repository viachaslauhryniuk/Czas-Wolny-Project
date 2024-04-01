
import SwiftUI
import Foundation
import Combine
final class ContentViewModel: ObservableObject{
 // MARK: Joint Variables
    @AppStorage("selectedGroup") var selectedGroup: String = ""
    @Published var activeTab:Tab = .groups
    @Published var selectedYear = 1
    @Published  var selectGroup = 1
    @Published  var selectedSpeciality = "IO"
    @Published var appear = false
    @Published var appearBackground = false
    @Published var years = [1, 2, 3]
    @Published var groups = [Array(1...11), Array(1...8), Array(1...3)]
    @Published var specialities = ["EAiBD", "TI", "IO"]
  
}






