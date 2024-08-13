//
//  FloatingView.swift
//  eTagApp
//
//  Created by Macbook on 07/06/24.
//

import UIKit
import AVKit
import SnapKit

class FloatingView: UIView {

  static let shared = FloatingView(frame: CGRect(x: .currentDeviceWidth - 170, y: .currentDeviceHeight / 2, width: 200, height: 400), videoURL: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)


  //  let playerViewController: AVPlayerViewController = {
  //    let playerViewController = AVPlayerViewController()
  //    playerViewController.allowsPictureInPicturePlayback = true
  //    playerViewController.videoGravity = .resizeAspectFill
  //    playerViewController.showsPlaybackControls = true
  ////    playerViewController.showsTimecodes = true
  //    playerViewController.view.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
  //    playerViewController.view.layer.borderWidth = 3.0
  //    playerViewController.view.layer.masksToBounds = true
  //    return playerViewController
  //  }()


  var playerViewController: AVPlayerViewController!

  let closeButton: UIButton = {
    let bt = UIButton(type: .system)
    if let closeImage = UIImage(systemName: "xmark.circle.fill") {
      bt.setImage(closeImage, for: .normal)
    }
    bt.tintColor = .gray
    return bt
  }()

  let labelContainerView: UIView = {
    let vi = UIView()
    vi.backgroundColor = .gray
    return vi
  }()

  let marqueeLabel: UILabel = {
    let lb = UILabel()
    lb.text = "Teks Berjalan di Bawah Panel Mengambang"
    lb.textColor = .white
    lb.numberOfLines = 0
    lb.font = UIFont.systemFont(ofSize: 14)

    let labelSize = lb.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 20))
    lb.frame = CGRect(x: 0, y: 0, width: labelSize.width, height: 20)
    return lb
  }()

  var player: AVPlayer!
  var playerItem: AVPlayerItem?
  var playerLayer: AVPlayerLayer!
  var pipController: AVPictureInPictureController?


  //MARK: -Floating icon
  private var sneakPeek = true
  private var floatingIconCenterX: CGFloat = 0
  private var floatingIconCenterY: CGFloat = 0

  init(frame: CGRect, videoURL: URL) {
    super.init(frame: frame)
    setupView(videoURL: videoURL)
    setupUI()
    labelContainerView.isHidden = true
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension FloatingView {

  private func setupView(videoURL: URL) {

    playerItem = AVPlayerItem(url: videoURL)
    player = AVPlayer(playerItem: playerItem)
    playerViewController = AVPlayerViewController()
    playerViewController.allowsPictureInPicturePlayback = true
    playerViewController.videoGravity = .resizeAspectFill
    playerViewController.showsPlaybackControls = true
    playerViewController.showsTimecodes = true
    playerViewController.view.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
    playerViewController.view.layer.borderWidth = 3.0
    playerViewController.view.layer.masksToBounds = true
    if #available(iOS 16.0, *) {
      playerViewController.allowsVideoFrameAnalysis =  false
    }
    playerViewController.player = player
    playerLayer = AVPlayerLayer(player: player)
    playerLayer.videoGravity = .resizeAspectFill


    if AVPictureInPictureController.isPictureInPictureSupported() {
      let playerLayer = AVPlayerLayer(player: player)
      pipController = AVPictureInPictureController(playerLayer: playerLayer)
    }

    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    self.addGestureRecognizer(panGesture)

    let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(dragHandler(gesture:)))
    self.addGestureRecognizer(dragGesture)

    //    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
    //    self.addGestureRecognizer(tapGesture)

    closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
  }

  private func setupUI() {
    self.backgroundColor = .clear
    self.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
    self.layer.masksToBounds = true

    self.addSubview(closeButton)
    self.addSubview(playerViewController.view)
    self.addSubview(labelContainerView)
    labelContainerView.addSubview(marqueeLabel)
    self.bringSubviewToFront(playerViewController.view)

    // Setup constraints after adding subviews
    closeButton.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(5)
      make.right.equalToSuperview()
      make.size.equalTo(30)
    }

    playerViewController.view.snp.makeConstraints { make in
      make.top.equalTo(closeButton.snp.bottom)
      make.horizontalEdges.equalToSuperview()
      make.bottom.equalToSuperview()
    }

    labelContainerView.snp.makeConstraints { make in
      make.left.right.bottom.equalToSuperview()
      make.height.equalTo(20)
    }

    marqueeLabel.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  func startMarqueeAnimation() {
    marqueeLabel.frame.origin.x = labelContainerView.frame.width
    UIView.animate(withDuration: 10, delay: 0, options: [.curveLinear, .repeat], animations: {
      self.marqueeLabel.frame.origin.x = -self.marqueeLabel.frame.width
    }, completion: nil)
  }

  func configure(withURL url: URL) {
    let playerItem = AVPlayerItem(url: url)
    player.pause()
    player.replaceCurrentItem(with: nil)  // Menghapus item pemutar saat ini
    player.replaceCurrentItem(with: playerItem)
  }


  func show(in view: UIView) {
    if self.superview == nil {
      view.addSubview(self)
      self.startMarqueeAnimation()
      self.show()
    }
  }

  func show() {
    self.alpha = 0.0
    UIView.animate(withDuration: 0.2) {
      self.alpha = 1.0
    }
    playerViewController.player?.play()
  }

  func close() {
    self.removeFromSuperview()
    playerViewController.player?.pause()
  }

  func startPictureInPicture() {
    guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
      print("Failed to get key window")
      return
    }

    guard let scene = window.windowScene else {
      print("Failed to get window scene")
      return
    }

    guard let playerLayer = playerLayer else {
      print("Failed to get playerLayer")
      return
    }

    if AVPictureInPictureController.isPictureInPictureSupported() {
      let pipController = AVPictureInPictureController(playerLayer: playerLayer)
      pipController?.startPictureInPicture()
    } else {
      print("Picture in Picture is not supported on this device")
    }
  }

}

// MARK: handle button
extension FloatingView {
  @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
    let translation = sender.translation(in: self)
    self.center = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
    sender.setTranslation(.zero, in: self)
  }

  @objc private func handleTapGesture(_ sender: UITapGestureRecognizer) {
    if let player = playerViewController.player {
      if player.timeControlStatus == .playing {
        player.pause()
      } else {
        player.play()
      }
    }
  }

  //MARK: - Handle drag floating icon
  @objc func dragHandler(gesture: UIPanGestureRecognizer) {
    let location = gesture.location(in: self.superview)
    let draggedView = gesture.view
    draggedView?.center = location

    if gesture.state == .changed || gesture.state == .ended {
      if self.frame.maxY >= self.superview?.frame.height ?? 0 - 83 {
        self.center.y = (self.superview?.frame.height ?? 0 - 83) - self.frame.height / 2
      }
    }

    if gesture.state == .ended {
      if self.frame.midX >= (self.superview?.frame.width ?? 0) / 2 {
        let rightLocation: CGFloat = (self.superview?.frame.width ?? 0) - (self.frame.width / 2)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
          self.center.x = rightLocation - 20
          self.center.y = self.getFloatingViewOriginY()
        }, completion: nil)
      } else {
        let leftLocation: CGFloat = self.frame.width / 2
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
          self.center.x = leftLocation + 20
          self.center.y = self.getFloatingViewOriginY()
        }, completion: nil)
      }
    }
    floatingIconCenterX = self.center.x
    floatingIconCenterY = self.center.y
  }

  private func getFloatingViewOriginY() -> CGFloat {
    if self.frame.minY <= (self.superview?.safeAreaInsets.top ?? 0) + 44 {
      let originY = (self.superview?.safeAreaInsets.top ?? 0) + 44 + (self.frame.height / 2)
      return originY
    }
    return self.center.y
  }

  @objc private func closeButtonTapped() {
    playerViewController.player?.pause()
    self.removeFromSuperview()
  }

}

