//
//  LiveShowCell.swift
//  eTagApp
//
//  Created by Macbook on 06/06/24.
//

import UIKit
import SwiftUI
import AVKit
import SnapKit


class LiveShowCell: UITableViewCell {

  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var contentImageView: UIView!
  @IBOutlet weak var imageLiveView: UIImageView!

  @IBOutlet weak var viewStack: UIStackView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var sendButton: UIButton!
  
  var playerViewController: AVPlayerViewController!
  var player: AVPlayer?
  var playerItem: AVPlayerItem?
  var urlString: String?


  var tapButton: (() -> Void)?

  override func awakeFromNib() {
    super.awakeFromNib()
//    setupFirst()

    setupUI()
    sendButton.setTitle("", for: .normal)
    sendButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
  }

  @objc func buttonTapped() {
    tapButton?()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    containerView.bringSubviewToFront(contentImageView)
    containerView.bringSubviewToFront(viewStack)
    containerView.bringSubviewToFront(sendButton)
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  func setupFirst() {

    // Inisialisasi AVPlayerViewController
    playerViewController = AVPlayerViewController()
    playerViewController.view.frame = containerView.bounds
    playerViewController.allowsPictureInPicturePlayback = true
    playerViewController.videoGravity = .resizeAspectFill

    containerView.addSubview(playerViewController.view)
  }

  private func setupUI() {
    // Set corner radius dan clipsToBounds untuk containerView
    contentImageView.layer.cornerRadius = contentImageView.frame.size.width / 2
    contentImageView.clipsToBounds = true
    imageLiveView.contentMode = .scaleAspectFill



  }

  func setupPlayerViewController(with videoURL: URL) {


    // Inisialisasi AVPlayerItem dengan URL video
    playerItem = AVPlayerItem(url: videoURL)

    // Pastikan playerItem tidak nil
    guard let playerItem = playerItem else {
      // Tangani kasus jika playerItem nil
      print("Error: AVPlayerItem is nil")
      return
    }

    // Inisialisasi AVPlayer dengan playerItem
    player = AVPlayer(playerItem: playerItem)

    // Inisialisasi AVPlayerViewController dan hubungkan dengan player
    playerViewController = AVPlayerViewController()
    playerViewController.player = player

    playerViewController.view.frame = containerView.bounds
    playerViewController.allowsPictureInPicturePlayback = true
    playerViewController.videoGravity = .resizeAspectFill

    containerView.addSubview(playerViewController.view)



  }

  func setupData(videos: VideoEntity) {
    urlString = videos.sources.first
    titleLabel.text = videos.title
    descriptionLabel.text = videos.description
    loadImage(from: videos.thumb)

    if let urlString = urlString, let videoURL = URL(string: urlString) {
      setupPlayerViewController(with: videoURL)
    }
  }

  func loadImage(from urlString: String) {
    guard let url = URL(string: urlString) else { return }

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data, error == nil else { return }
      DispatchQueue.main.async { [weak self] in
        self?.imageLiveView.image = UIImage(data: data)
      }
    }
    task.resume()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    player?.pause()
    player = nil
    playerViewController.view.removeFromSuperview()
    playerViewController = nil
  }

  func play() {
    player?.play()
  }

  func pause() {
    player?.pause()
  }
}
