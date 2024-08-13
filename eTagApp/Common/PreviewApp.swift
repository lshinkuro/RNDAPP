//
//  PreviewApp.swift
//  eTagApp
//
//  Created by Macbook on 27/05/24.
//

import Foundation
import SnapKit
import SwiftUI

struct PreviewContainer<T: UIViewController>: UIViewControllerRepresentable {

  let viewController: T

  init(_ viewControllerBuilder: @escaping () -> T) {
    viewController = viewControllerBuilder()
  }

  // MARK: - UIViewControllerRepresentable
  func makeUIViewController(context: Context) -> T {
    return viewController
  }

  func updateUIViewController(_ uiViewController: T, context: Context) {}
}

@available(iOS 13.0, *)
func previewViewController<T: UIViewController>(_ viewController: T) -> some View {
  PreviewContainer {
    viewController
  }
}


// Define a struct conforming to UIViewRepresentable
struct PreviewContainerView<T: UIView>: UIViewRepresentable {

  let view: T

  init(_ viewBuilder: @escaping () -> T) {
    view = viewBuilder()
  }

  // Implement the makeUIView method to create your custom UIKit view
  func makeUIView(context: Context) -> T {
    return view
  }

  // Implement the updateUIView method to configure your custom UIKit view
  func updateUIView(_ uiView: T, context: Context) {
    // Update your custom input field view if needed
  }
}

@available(iOS 13.0, *)
func previewView<T: UIView>(_ view: T) -> some View {
  PreviewContainerView {
    view
  }
}

