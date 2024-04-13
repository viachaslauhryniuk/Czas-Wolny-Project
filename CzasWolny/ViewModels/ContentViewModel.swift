import SwiftUI
import Foundation
import Combine
import FirebaseFirestore
import UserNotifications
import FirebaseAuth
final class ContentViewModel: ObservableObject {

 // MARK: Joint Variables
    @Published var tasks: [Task] = []
    @Published var deletedTasks: [Task] = [] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(deletedTasks) {
                UserDefaults.standard.set(encoded, forKey: "DeletedTasks")
            }

        }
    }
    @Published var isChatViewActive = false

    @Published var activeTab: Tab = .groups
    @Published var selectedYear = 1
    @Published var selectGroup = 1
    @Published var selectedSpeciality = "IO"
    @Published var appear = false
    @Published var appearBackground = false
    @Published var years = [1, 2, 3]
    @Published var groups = [Array(1...11), Array(1...8), Array(1...3)]
    @Published var specialities = ["EAiBD", "TI", "IO"]
    @Published var email = ""
    @AppStorage ("selectedGroup") var selectedGroup: String = ""

    init() {
   //    checkUser()
        if let savedItems = UserDefaults.standard.data(forKey: "DeletedTasks"),
           let decodedItems = try? JSONDecoder().decode([Task].self, from: savedItems) {
            self.deletedTasks = decodedItems
        } else {
            self.deletedTasks = []
        }
      // self.selectedGroup = UserDefaults.standard.string(forKey: "\(email)selectedGroup") ?? ""
    }
    func checkUser() {
        if let user = Auth.auth().currentUser {
            self.email = user.email!
        } else {
        // No user is signed in.
        }
    }

    func fetchTasks() {
        let db = Firestore.firestore()
        let tasksRef = db.collection("tasks")
        let query = tasksRef.whereField("group", isEqualTo: selectedGroup)

        query.getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.tasks = querySnapshot.documents.compactMap { document -> Task? in
                    if var task = try? document.data(as: Task.self) {
                                        self.scheduleNotification(for: task)
                                        return task
                                    } else {
                                        return nil
                                    }
                                }
                self.tasks = self.tasks.filter { task in
                    !self.deletedTasks.contains(where: { $0.id == task.id })
                }
            } else if let error = error {
                print("Error getting tasks: \(error)")
            }
        }
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "pl_PL")
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            return formatter.string(from: date)
    }

    func scheduleNotification(for task: Task) {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = "You have a task due soon: \(task.title)"
        content.sound = .default

        let triggerDate = Calendar.current.date(byAdding: .hour, value: -1, to: task.deadline.dateValue())!
        let triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)

        let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)
        center.add(request)
    }

    func notificationpermission() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied because: \(String(describing: error?.localizedDescription)).")
            }
        }
    }
    func deleteTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            deletedTasks.append(tasks[index])
            tasks.remove(at: index)
        }
    }

    }
