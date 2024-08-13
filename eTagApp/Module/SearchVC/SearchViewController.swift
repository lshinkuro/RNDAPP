//
//  SearchViewController.swift
//  eTagApp
//
//  Created by Macbook on 10/06/24.
//


import UIKit
import AVKit
import AVFoundation

class SearchViewController: UIViewController {

  var playerViewController: AVPlayerViewController!
  var pipController: AVPictureInPictureController?
  var player: AVPlayer?
  var playerLayer: AVPlayerLayer?
  var playerItem: AVPlayerItem?


  override func viewDidLoad() {
    super.viewDidLoad()

    // Setup AVPlayer
    guard let url = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4") else {
      return
    }

    player = AVPlayer(url: url)
    player?.isMuted = false
    player?.play()

    // Setup AVPlayerViewController
    playerViewController = AVPlayerViewController()
    playerViewController.player = player
    playerViewController.allowsPictureInPicturePlayback = true
    playerViewController.delegate = self

    // Add AVPlayerViewController's view to current view
    self.addChild(playerViewController)
    self.view.addSubview(playerViewController.view)
    playerViewController.view.frame = self.view.bounds
    playerViewController.didMove(toParent: self)

//    playerItem = AVPlayerItem(url: url)
//    player = AVPlayer(playerItem: playerItem)
//    player?.play()

    playerLayer = AVPlayerLayer(player: player)
    guard let playerLayer = playerLayer else { return }
    playerLayer.videoGravity = .resizeAspect
//    playerLayer.frame = self.view.bounds
    self.view.layer.addSublayer(playerLayer)

    // Setup PiP
    if AVPictureInPictureController.isPictureInPictureSupported() {
      pipController = AVPictureInPictureController(playerLayer: playerLayer)
      pipController?.delegate = self
      if #available(iOS 14.2, *) {
          pipController?.canStartPictureInPictureAutomaticallyFromInline = true
      }
    } else {
      // Show alert if PiP is not supported
      let alert = UIAlertController(title: "Not Supported", message: "Picture in Picture is not supported on this device.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default))
      self.present(alert, animated: true)
    }

    // Add PiP Button
    let pipButton = UIButton(type: .system)
    pipButton.setTitle("Start PiP", for: .normal)
    pipButton.addTarget(self, action: #selector(startPictureInPicture), for: .touchUpInside)
    pipButton.frame = CGRect(x: 20, y: 50, width: 100, height: 50)
    self.view.addSubview(pipButton)

    // Observe app state changes
    NotificationCenter.default.addObserver(self, selector: #selector(handleAppStateChange), name: UIApplication.didBecomeActiveNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handleAppStateChange), name: UIApplication.willResignActiveNotification, object: nil)
  }


  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if player?.timeControlStatus == .playing {
      startPictureInPicture()
    }
  }


  deinit {
    NotificationCenter.default.removeObserver(self)
  }

}

extension SearchViewController {

  @objc func startPictureInPicture() {
    guard let pipController = pipController, pipController.isPictureInPictureActive == false else {
      return
    }
    pipController.startPictureInPicture()
  }

  @objc func stopPictureInPicture() {
    guard let pipController = pipController, pipController.isPictureInPictureActive == true else {
      return
    }
    pipController.stopPictureInPicture()
  }

  @objc func handleAppStateChange(notification: NSNotification) {
    if notification.name == UIApplication.didBecomeActiveNotification {
      // App became active
      print("App became active")
    } else if notification.name == UIApplication.willResignActiveNotification {
      // App will resign active
      print("App will resign active")
      if player?.timeControlStatus == .playing {
        startPictureInPicture()
      }
    }
  }

}

extension SearchViewController: AVPictureInPictureControllerDelegate, AVPlayerViewControllerDelegate {
  // MARK: - AVPictureInPictureControllerDelegate
  func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
    print("PiP will start")
  }

  func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
    print("PiP did start")
  }

  func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
    print("Failed to start PiP: \(error)")
  }

  func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
    print("PiP will stop")
  }

  func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
    print("PiP did stop")
  }
}


//
//  SearchViewController.swift
//  eTagApp
//
//  Created by Macbook on 10/06/24.
//

/*import UIKit
import AVKit
import AVFoundation

class SearchViewController: UIViewController {

    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var pipController: AVPictureInPictureController?
    var playerItem: AVPlayerItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup AVPlayer
        guard let url = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4") else {
            return
        }

        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)

        // Setup AVPlayerLayer
        playerLayer = AVPlayerLayer(player: player)
        guard let playerLayer = playerLayer else { return }
        playerLayer.videoGravity = .resizeAspect
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)

        // Play the video
        player?.play()

        // Setup PiP
        if AVPictureInPictureController.isPictureInPictureSupported() {
            pipController = AVPictureInPictureController(playerLayer: playerLayer)
            pipController?.delegate = self
            if #available(iOS 14.2, *) {
                pipController?.canStartPictureInPictureAutomaticallyFromInline = true
            }
        } else {
            // Show alert if PiP is not supported
            let alert = UIAlertController(title: "Not Supported", message: "Picture in Picture is not supported on this device.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }

        // Add PiP Button
        let pipButton = UIButton(type: .system)
        pipButton.setTitle("Start PiP", for: .normal)
        pipButton.addTarget(self, action: #selector(startPictureInPicture), for: .touchUpInside)
        pipButton.frame = CGRect(x: 20, y: 50, width: 100, height: 50)
        self.view.addSubview(pipButton)

        // Observe app state changes
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppStateChange), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppStateChange), name: UIApplication.willResignActiveNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if player?.timeControlStatus == .playing {
            startPictureInPicture()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func startPictureInPicture() {
        guard let pipController = pipController, pipController.isPictureInPictureActive == false else {
            return
        }
        pipController.startPictureInPicture()
    }

    @objc func stopPictureInPicture() {
        guard let pipController = pipController, pipController.isPictureInPictureActive == true else {
            return
        }
        pipController.stopPictureInPicture()
    }

    @objc func handleAppStateChange(notification: NSNotification) {
        if notification.name == UIApplication.didBecomeActiveNotification {
            // App became active
            print("App became active")
        } else if notification.name == UIApplication.willResignActiveNotification {
            // App will resign active
            print("App will resign active")
            if player?.timeControlStatus == .playing {
                startPictureInPicture()
            }
        }
    }
}

extension SearchViewController: AVPictureInPictureControllerDelegate {
    // MARK: - AVPictureInPictureControllerDelegate
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("PiP will start")
    }

    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("PiP did start")
    }

    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
        print("Failed to start PiP: \(error)")
    }

    func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("PiP will stop")
    }

    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("PiP did stop")
    }
}*/

