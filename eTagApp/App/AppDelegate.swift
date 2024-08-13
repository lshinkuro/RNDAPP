//
//  AppDelegate.swift
//  eTagApp
//
//  Created by Macbook on 27/05/24.
//

import UIKit
#if DEV || DEBUG
import FLEX
#endif

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // FLEX setup for global use
    #if DEBUG
    FLEXManager.shared.showExplorer()
    #endif
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }


}

extension UIWindow {
  open override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    // code you want to implement
    #if DEV || DEBUG
    if motion == .motionShake {
        guard let view = UIApplication.topViewController() else {
            return
        }

      if view.responds(to: Selector(("shouldForceLandscape"))) {
          // If the rootViewController should force landscape, do not handle shake
          return
      }
      showSimpleActionSheet(controller: view)
    }
    #endif
  }

  func showSimpleActionSheet(controller: UIViewController) {
    // show FLEX
    #if DEV || DEBUG
    FLEXManager.shared.showExplorer()
    #endif
  }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}


