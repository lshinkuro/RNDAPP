//
//  SceneDelegate.swift
//  eTagApp
//
//  Created by Macbook on 27/05/24.
//

import UIKit
import ComposableArchitecture

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = UINavigationController(rootViewController: TCATestAPIViewController())
    window?.makeKeyAndVisible()

    // Ensure FloatingView is always on top
    //setupFloatingView()

  }

  private func setupFloatingView() {
      guard let window = window else { return }
      FloatingView.shared.show(in: window)
      window.bringSubviewToFront(FloatingView.shared)
  }

  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
  }

  func sceneDidBecomeActive(_ scene: UIScene) {

    if let window = window {
              window.bringSubviewToFront(FloatingView.shared)
  }
//
//    NotificationCenter.default.addObserver(self, selector: #selector(bringFloatingViewToFront), name: UIWindow.didBecomeKeyNotification, object: nil)

    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }

  @objc private func bringFloatingViewToFront() {
        guard let window = window else { return }
        window.bringSubviewToFront(FloatingView.shared)
    }

  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }

  func sceneDidEnterBackground(_ scene: UIScene) {

    guard let rootViewController = window?.rootViewController as? PIPStepTwoViewController else {
            return
        }
    rootViewController.startPictureInPicture()
//    (window?.rootViewController as? PIPStepTwoViewController)?.startPictureInPicture()
  }


}

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

