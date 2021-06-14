import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = self.window ?? UIWindow()
        self.window?.backgroundColor = UIColor().colorFromHexString(background_color)
        self.window!.rootViewController = ProfileViewController()
        self.window!.makeKeyAndVisible()
        UIFont.overrideInitialize()
        
        _ = CacheManager.instance.clearExpiredObjects()
        return true
    }
}

