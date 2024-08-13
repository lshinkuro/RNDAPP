//
//  PictureInPictureViewController.swift
//  eTagApp
//
//  Created by Macbook on 05/06/24.
//

import UIKit
import SwiftUI
import AVKit
import AVFoundation

/*@available(iOS 13.0, *)
 struct ViewController_Previews: PreviewProvider {
 static var previews: some View {
 previewViewController(PictureInPictureViewController())
 }
 }*/

class PictureInPictureViewController: UIViewController {


  @IBOutlet weak var tableView: UITableView!

  var lastVisibleIndexPath: IndexPath?
  var listVideo: ResponseVideoEntity = .mock

  override func viewDidLoad() {
    super.viewDidLoad()
    registerTableView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // Hide the navigation bar
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    // Show the navigation bar
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
    // Hentikan pemutaran video di semua sel yang terlihat
    stopAllVisibleCells()
  }


  func stopAllVisibleCells() {
    guard let visibleCells = tableView.visibleCells as? [LiveShowCell] else {
      return
    }

    for cell in visibleCells {
      cell.pause()
    }
  }

  @IBAction func buttonTapped(_ sender: Any) {
  }


  func registerTableView() {
    // Register the XIB for the tableview cell
    let nib = UINib(nibName: "LiveShowCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: "LiveShowCell")
    tableView.delegate = self
    tableView.dataSource = self
  }



}

extension PictureInPictureViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {


  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listVideo.categories.first?.videos.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "LiveShowCell", for: indexPath) as? LiveShowCell else {
      return UITableViewCell()
    }

    // Konfigurasi cell
    guard let dataVideo = listVideo.categories.first?.videos[indexPath.row] else { return UITableViewCell() }
    cell.setupData(videos: dataVideo)
    cell.tapButton = {
      self.navigationToPIPStepTwo(url: dataVideo.sources.first ?? "")
    }

    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableView.bounds.height
  }

  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let cellHeight = tableView.frame.size.height
    let targetY = targetContentOffset.pointee.y
    let index = round(targetY / cellHeight)
    targetContentOffset.pointee = CGPoint(x: 0, y: index * cellHeight)
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let visibleIndexPaths = tableView.indexPathsForVisibleRows ?? []

    // Jika tidak ada sel yang terlihat, keluar dari metode
    guard let lastIndexPath = visibleIndexPaths.last else {
      return
    }

    // Memainkan video di sel terakhir yang terlihat
    if let lastVisibleCell = tableView.cellForRow(at: lastIndexPath) as? LiveShowCell {
      lastVisibleCell.play()
    }

    // Menghentikan video di sel sebelumnya jika ada
    if let previousVisibleIndexPath = lastVisibleIndexPath,
       let previousVisibleCell = tableView.cellForRow(at: previousVisibleIndexPath) as? LiveShowCell {
      previousVisibleCell.pause()
    }

    // Menyimpan indeks path terakhir yang terlihat
    lastVisibleIndexPath = lastIndexPath
  }
}

extension PictureInPictureViewController {
  func navigationToPIPStepTwo(url: String) {
    let vc = PIPStepTwoViewController()
    vc.videoURL = URL(string: url)
//    vc.hidesBottomBarWhenPushed =  true
    self.navigationController?.pushViewController(vc, animated:true)
  }
}

