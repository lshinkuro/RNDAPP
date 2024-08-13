//
//  MainTabBarController.swift
//  eTagApp
//
//  Created by Macbook on 10/06/24.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

  let btnMiddle : UIButton = {
    let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    btn.setTitle("", for: .normal)
    btn.setImage(UIImage(systemName: "snowflake"), for: .normal)
    btn.backgroundColor = .white
    btn.layer.cornerRadius = 30
    btn.layer.shadowColor = UIColor.black.cgColor
    btn.layer.shadowOpacity = 0.2
    btn.layer.shadowOffset = CGSize(width: 4, height: 4)
    btn.setBackgroundImage(UIImage(named: "ic_cart"), for: .normal)

    return btn
  }()

  // Inisialisasi tampilan-tampilan utama
  let homeViewController = UINavigationController(rootViewController: PictureInPictureViewController())
  let searchViewController = UINavigationController(rootViewController: SearchViewController())
  let midlleViewController = UINavigationController(rootViewController: UIViewController())
  let favoriteViewController = UINavigationController(rootViewController: FavoritesViewController())
  let profileViewController = UINavigationController(rootViewController: ProfileViewController())


  override func viewDidLoad() {
    super.viewDidLoad()
    configureTabBar()
    configureUITabBarItems()
    btnMiddle.frame = CGRect(x: Int(self.tabBar.bounds.width)/2 - 30, y: -20, width: 60, height: 60)
    btnMiddle.addTarget(self, action: #selector(btnMiddleTapped), for: .touchUpInside)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    hideNavigationBar()
  }

  override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      // Ensure the layout is updated
      view.layoutIfNeeded()
  }


  func hideNavigationBar() {
    self.navigationController?.isToolbarHidden = true
    self.navigationController?.isNavigationBarHidden = true
    self.navigationController?.navigationBar.isTranslucent = false

    hidesBottomBarWhenPushed = false
  }

  func setHiddenTabBar(_ hidden: Bool, animated: Bool) {
    let tabBar = self.tabBar
    let screenHeight =  UIScreen.main.bounds.height
    let tabBarHeight = tabBar.frame.height

    let offsetY = hidden ? screenHeight + 30.0 : screenHeight - tabBarHeight

    UIView.animate(withDuration: animated ? 0.3 : 0.0) {
      tabBar.frame.origin.y = offsetY
    }
  }

  override func loadView() {
    super.loadView()
    self.tabBar.addSubview(btnMiddle)
    setupCustomTabBar()

  }

  @objc func btnMiddleTapped() {
//    let vc = CartViewController()
//    navigationController?.pushViewController(vc, animated: true)
  }

  func configureUITabBarItems(){

    // Atur tab bar item untuk setiap tampilan
    homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.circle"), selectedImage: nil)
    searchViewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName:  "qrcode.viewfinder"), selectedImage: nil)
    favoriteViewController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName:  "backpack.circle"), selectedImage: nil)
    profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), selectedImage: nil)

    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: .selected)

    UITabBar.appearance().tintColor = UIColor.red
    self.tabBar.unselectedItemTintColor = UIColor.white
    self.tabBar.tintColor = UIColor.label
    self.tabBar.backgroundColor = UIColor.systemBackground
    self.tabBar.backgroundColor = UIColor.clear

  }

  func configureTabBar() {
    //    self.delegate = self
    // Tetapkan tampilan-tampilan ke tab bar controller
    setViewControllers([homeViewController, searchViewController,midlleViewController,favoriteViewController, profileViewController], animated: true)
  }

  //MARK: - UITabbar Delegate
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    if viewController.isKind(of: ProfileViewController.self) {
      let vc =  ProfileViewController()
      vc.modalPresentationStyle = .overFullScreen
      self.present(vc, animated: true, completion: nil)
      return false
    }
    return true
  }

}


extension MainTabBarController {
  func setupCustomTabBar() {
      let path: UIBezierPath = getPathForTabBar()
      let shape = CAShapeLayer()
      shape.path = path.cgPath
      shape.lineWidth = 3
      shape.strokeColor = UIColor.white.cgColor
      shape.fillColor = UIColor.white.cgColor
      self.tabBar.layer.insertSublayer(shape, at: 0)
      self.tabBar.itemWidth = 40
      self.tabBar.itemPositioning = .centered
      self.tabBar.itemSpacing = 70
      self.tabBar.tintColor = UIColor.label
      self.tabBar.unselectedItemTintColor = UIColor.white
      self.tabBar.isTranslucent = true
      self.tabBar.barTintColor = UIColor.clear
      self.tabBar.backgroundColor = UIColor.clear

      if #available(iOS 15.0, *) {
          let appearance = UITabBarAppearance()
          appearance.configureWithTransparentBackground()
          tabBar.standardAppearance = appearance
          tabBar.scrollEdgeAppearance = appearance
      }

  }



  func getPathForTabBar() -> UIBezierPath {
      let holeWidth: CGFloat = 170
      let holeHeight: CGFloat = 70
      let frameWidth = self.tabBar.bounds.width
      let frameHeight = self.tabBar.bounds.height + 40
      let leftXUntilHole = frameWidth / 2 - holeWidth / 2


      let path = UIBezierPath()

      // Move to the starting point
      path.move(to: CGPoint(x: 0, y: 0))

      // 1. Line
      path.addLine(to: CGPoint(x: leftXUntilHole, y: 0))

      // Part I
      path.addCurve(to: CGPoint(x: leftXUntilHole + (holeWidth / 3), y: holeHeight / 2),
                    controlPoint1: CGPoint(x: leftXUntilHole + ((holeWidth / 3) / 8) * 6, y: 0),
                    controlPoint2: CGPoint(x: leftXUntilHole + ((holeWidth / 3) / 8) * 8, y: holeHeight / 2))

      // Part II
      path.addCurve(to: CGPoint(x: leftXUntilHole + (2 * holeWidth) / 3, y: holeHeight / 2),
                    controlPoint1: CGPoint(x: leftXUntilHole + (holeWidth / 3) + (holeWidth / 3) / 3 * 2 / 5, y: (holeHeight / 2) * 6 / 4),
                    controlPoint2: CGPoint(x: leftXUntilHole + (holeWidth / 3) + (holeWidth / 3) / 3 * 2 + (holeWidth / 3) / 3 * 3 / 5, y: (holeHeight / 2) * 6 / 4))

      // Part III
      path.addCurve(to: CGPoint(x: leftXUntilHole + holeWidth, y: 0),
                    controlPoint1: CGPoint(x: leftXUntilHole + (2 * holeWidth) / 3, y: holeHeight / 2),
                    controlPoint2: CGPoint(x: leftXUntilHole + (2 * holeWidth) / 3 + (holeWidth / 3) * 2 / 8, y: 0))

      // 2. Line
      path.addLine(to: CGPoint(x: frameWidth, y: 0))

      // 3. Line
      path.addLine(to: CGPoint(x: frameWidth, y: frameHeight))

      // 4. Line
      path.addLine(to: CGPoint(x: 0, y: frameHeight))

      // 5. Line
      path.addLine(to: CGPoint(x: 0, y: 0))

      // Close the path
      path.close()

      return path
  }
}

