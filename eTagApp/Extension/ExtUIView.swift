//
//  ExtUIView.swift
//  eTagApp
//
//  Created by Macbook on 27/05/24.
//

import Foundation
import UIKit

extension UIView {
  func setGradient() {
    self.layer.cornerRadius = 20
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOffset = CGSize(width: 0, height: 2) // Arah bayangan (x, y)
    self.layer.shadowOpacity = 0.5 // Opasitas bayangan
    self.layer.shadowRadius = 4 // Radius bayangan
    self.layer.masksToBounds = false // Menonaktifkan pemotongan bayangan
    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor.clear.cgColor
  }
}


extension CGFloat {
    static let currentDeviceWidth  = UIScreen.main.bounds.width
    static let currentDeviceHeight = UIScreen.main.bounds.height
}
