//
//  PIPStepTwoViewController.swift
//  eTagApp
//
//  Created by Macbook on 06/06/24.
//

import UIKit
import SwiftUI
import AVKit
import AVFoundation
import SnapKit

class PIPStepTwoViewController: UIViewController {
  var videoURL: URL? = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")

  var pipController: AVPictureInPictureController?


  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)

  }


  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let url = videoURL {
      FloatingView.shared.configure(withURL: url)
      FloatingView.shared.show(in: self.view)
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
  }

  /*override func viewWillDisappear(_ animated: Bool) {
   super.viewWillDisappear(animated)
   FloatingView.shared.close()
   }*/

  func setupView() {
    navigationItem.title = "Test Picture in Picture"
  }

  @objc private func didEnterBackground() {
    startPictureInPicture()
  }

  func startPictureInPicture() {
    guard let playerLayer = FloatingView.shared.playerLayer else {
      print("Failed to get playerLayer from playerViewController")
      return
    }

    if AVPictureInPictureController.isPictureInPictureSupported() {
      if let pipController = AVPictureInPictureController(playerLayer: playerLayer) {
        pipController.startPictureInPicture()
      } else {
        print("Failed to create AVPictureInPictureController")
      }
    } else {
      print("Picture in Picture is not supported on this device")
    }
  }
}
