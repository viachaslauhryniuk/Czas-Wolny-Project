
import Firebase
import SwiftUI
import FirebaseAuth

@main
struct CzasWolnyApp: App {
   
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

        var body: some Scene {
            WindowGroup {
                if Auth.auth().currentUser != nil {
                    MainView()
                } else {
                    EnterView() 
                }
            }
        }
    }

    class AppDelegate: UIResponder, UIApplicationDelegate {
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            let providerFactory = AppCheckDebugProviderFactory()
            AppCheck.setAppCheckProviderFactory(providerFactory)
            FirebaseApp.configure()
            return true
        }
    }
