
import UIKit
import RxFlow
import RxSwift
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var coordinator = FlowCoordinator()
  var disposeBag = DisposeBag()
  
  private var currentFlow: String?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.makeKeyAndVisible()
    self.window = window
    
    registerForRemoteNotifications()
    BonMotManagr.setupStyles()
    setupFlow()

    debugPrint("*** realm 위치: ", Realm.Configuration.defaultConfiguration.fileURL!)
    
    return true
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    return false
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    let realm = try! Realm()
    realm.delete(realm.objects(ProductModel.self))
  }
}

// MARK: - Managers
extension AppDelegate {
  private func setupFlow() {
    guard let window = self.window else { return }
    
    let appFlow = AppFlow(window: window)
    self.coordinator.coordinate(flow: appFlow, with: AppStepper())
    Flows.use(appFlow, when: .created) { root in
        window.rootViewController = root
        window.makeKeyAndVisible()
    }
  }
}


// MARK: - Push Notification

extension AppDelegate: UNUserNotificationCenterDelegate {
  
  /// 푸시 알림 설정
  func registerForRemoteNotifications() {
    UNUserNotificationCenter.current().delegate = self
//    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
  }
  
  /// 푸시 알림이 보여질 때 호출
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.banner, .sound, .badge])
  }
  
  /// 푸시 알림을 클릭할 때 호출
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    completionHandler()
  }
  
}

