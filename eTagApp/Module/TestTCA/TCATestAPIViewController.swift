//
//  TCATestAPIViewController.swift
//  eTagApp
//
//  Created by Macbook on 04/06/24.
//

import UIKit
import SnapKit
import SwiftUI
import AlamofireImage
import Combine
import ComposableArchitecture



class TCATestAPIViewController: UIViewController {
  
  let tableView: UITableView = {
    let tv = UITableView(frame: .zero)
    tv.backgroundColor = .white
    let cellIdentifier = "CustomTableViewCell"
    tv.register(CustomTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    return tv
  }()

  let store: StoreOf<FetchDataFeature>
  let viewStore: ViewStore<FetchDataFeature.State, FetchDataFeature.Action>
  private var cancellables = Set<AnyCancellable>()

  init(store: StoreOf<FetchDataFeature> = Store(initialState: FetchDataFeature.State(), reducer: { FetchDataFeature() })) {
    self.store = store
    self.viewStore = ViewStore(store, observe: { $0 })
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    viewStore.send(.fetchStories)
    bindingData()
  }

  func bindingData() {
    // Bind viewStore state to UI using Combine
    viewStore.publisher
      .map { $0.data}
      .receive(on: DispatchQueue.main) // Specify the scheduler
      .sink { [weak self] state in
        self?.tableView.reloadData()
      }
      .store(in: &cancellables)
  }

  func setupView() {
    // Set delegate dan data source
    tableView.delegate = self
    tableView.dataSource = self

    self.view.addSubview(tableView)

    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

  }


}

extension TCATestAPIViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewStore.data.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell else {
          return UITableViewCell()
      }

      let data = viewStore.data[indexPath.row]

      cell.titleLabel.text = data.title
      cell.descriptionLabel.text = data.body
      cell.cellImageView.image = UIImage(named: "")

      return cell
  }

}
