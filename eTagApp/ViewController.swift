//
//  ViewController.swift
//  eTagApp
//
//  Created by Macbook on 27/05/24.
//

import UIKit
import SnapKit
import SwiftUI
import AlamofireImage
import Combine
import ComposableArchitecture




class ViewController: UIViewController {

  var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.backgroundColor = .clear
    return scrollView
  }()

  var containerView: UIView = {
    let vk = UIView()
    vk.backgroundColor = .blue
    vk.layer.cornerRadius = 20
    vk.setGradient()
    return vk
  }()

  var stackView: UIStackView = {
    let sv = UIStackView()
    sv.alignment = .center
    sv.axis = .vertical
    sv.alignment = .fill
    sv.distribution = .fillEqually
    return sv
  }()

  var leftLabel: UILabel = {
    let lb = UILabel()
    lb.text = "Test 1"
    lb.textColor = .white
    return lb
  }()

  var rightLabel: UILabel = {
    let lb = UILabel()
    lb.text = "Test 2"
    lb.textColor = .white
    return lb
  }()

  let buttonA: UIButton = { () -> UIButton in
    let ui = UIButton()
    ui.titleLabel?.numberOfLines = 0
    ui.setTitle("Click\nA", for: .normal)
    ui.backgroundColor = UIColor.blue
    return ui
  }()

  let buttonB: UIButton = { () -> UIButton in
    let ui = UIButton()
    ui.titleLabel?.numberOfLines = 0
    ui.setTitle("Click\nB", for: .normal)
    ui.backgroundColor = UIColor.gray
    return ui
  }()

  let buttonC: UIButton = { () -> UIButton in
    let ui = UIButton()
    ui.titleLabel?.numberOfLines = 0
    ui.setTitle("Add", for: .normal)
    ui.backgroundColor = UIColor.black
    return ui
  }()

  let containerB: UIView = {
    let vk = UIView()
    vk.backgroundColor = .blue
    vk.layer.cornerRadius = 20
    vk.setGradient()
    return vk
  }()

  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.backgroundColor = .clear
    let cellIdentifier = "CustomCollectionViewCell"
    cv.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)

    return cv
  }()

  let pokemonImage: UIImageView = {
    let img = UIImageView()
    img.contentMode = .scaleAspectFill
    return img
  }()

  var arrString: [String] = [ "agus maulana", "ahmad", "bagas", "wulan", "dewi", "andre", "agus"]

  let store: StoreOf<CounterFeature>
  let viewStore: ViewStore<CounterFeature.State, CounterFeature.Action>
  private var cancellables = Set<AnyCancellable>()

  init(store: StoreOf<CounterFeature> = Store(initialState: CounterFeature.State(), reducer: { CounterFeature() })) {
    self.store = store
    self.viewStore = ViewStore(store, observe: { $0 })
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor =  .red
    setupView()

    // Mengatur delegate dan data source
    collectionView.delegate = self
    collectionView.dataSource = self

    buttonA.addTarget(self, action: #selector(buttonAClicked(sender:)), for: .touchUpInside)
    buttonB.addTarget(self, action: #selector(buttonAClicked(sender:)), for: .touchUpInside)
    buttonC.addTarget(self, action: #selector(addItemButtonTapped(sender:)), for: .touchUpInside)

    viewStore.state.items.forEach { x in
      let label = createLabelTemplate()
      label.text = x
      stackView.addArrangedSubview(label)
    }

    ImageAssetHelper.shared.fetchImage(imageView: pokemonImage)
    bindingData()
  }

  func bindingData() {
    // Bind viewStore state to UI using Combine
    viewStore.publisher
      .map { $0.count}
      .removeDuplicates() // Menghapus nilai-nilai yang duplikat
      .receive(on: DispatchQueue.main) // Specify the scheduler
      .sink { [weak self] state in
        self?.rightLabel.text = "Count: \(state)"
      }
      .store(in: &cancellables)


    viewStore.publisher
      .map { $0.items}
      .removeDuplicates() // Menghapus nilai-nilai yang duplikat
      .receive(on: DispatchQueue.main) // Specify the scheduler
      .sink { [weak self] state in
        self?.collectionView.reloadData()
      }
      .store(in: &cancellables)
  }

  func createLabelTemplate() -> UILabel {
    let label = UILabel()
    label.textColor = leftLabel.textColor
    label.textAlignment = leftLabel.textAlignment
    return label
  }

  func setupView() {
    view.addSubview(containerView)
    view.addSubview(rightLabel)
    view.addSubview(buttonA)
    view.addSubview(buttonB)
    view.addSubview(buttonC)
    containerView.addSubview(stackView)

    view.addSubview(containerB)
    containerB.addSubview(pokemonImage)
    containerB.addSubview(collectionView)

    buttonA.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.top.equalToSuperview().offset(60)
      make.height.equalTo(60)
    }

    buttonB.snp.makeConstraints { (make) in
      make.left.equalTo(buttonA.snp.right)
      make.top.equalToSuperview().offset(60)
      make.width.equalTo(buttonA.snp.width)
      make.height.equalTo(buttonA.snp.height)
    }

    buttonC.snp.makeConstraints { (make) in
      make.left.equalTo(buttonB.snp.right)
      make.right.equalToSuperview()
      make.top.equalToSuperview().offset(60)
      make.width.equalTo(buttonA.snp.width)
      make.height.equalTo(buttonA.snp.height)
    }

    rightLabel.snp.makeConstraints { make in
      make.top.equalTo(buttonA.snp.bottom).offset(20)
      make.horizontalEdges.equalToSuperview().offset(10)

    }

    containerView.snp.makeConstraints { make in
      make.top.equalTo(rightLabel.snp.bottom).offset(20)
      make.left.equalToSuperview().offset(10)
      make.right.equalToSuperview().offset(-10)
      make.height.equalTo(80)
    }

    stackView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.verticalEdges.equalToSuperview().inset(10)
    }

    containerB.snp.makeConstraints { make in
      make.top.equalTo(containerView.snp.bottom).offset(20)
      make.left.equalToSuperview().offset(10)
      make.right.equalToSuperview().offset(-10)
      make.height.equalTo(80)
    }

    pokemonImage.snp.makeConstraints { make in
      make.left.equalToSuperview()
      make.top.equalToSuperview().offset(-20)
      make.height.equalTo(120)
      make.width.equalTo(100)
    }

    collectionView.snp.makeConstraints { make in
      make.left.equalTo(pokemonImage.snp.right)
      make.top.right.bottom.equalToSuperview()
    }

  }


  @objc func buttonAClicked(sender: UIButton) {
    switch sender {
    case buttonA:
      buttonA.backgroundColor = UIColor.blue
      buttonB.backgroundColor = UIColor.gray
      UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut) {
        self.containerView.snp.updateConstraints { (make) in
          make.height.equalTo(50)
        }
        self.view.layoutIfNeeded()
      }

      viewStore.send(.decrementButtonTapped)
    case buttonB:
      buttonA.backgroundColor = UIColor.gray
      buttonB.backgroundColor = UIColor.blue
      UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut) {
        self.containerView.snp.updateConstraints { (make) in
          make.height.equalTo(150)
        }
        self.view.layoutIfNeeded()
      }
      viewStore.send(.incrementButtonTapped)
    default:
      break
    }
  }

  @objc func addItemButtonTapped(sender: UIButton) {
      let alertController = UIAlertController(title: "Add Item", message: "Enter item name:", preferredStyle: .alert)
      alertController.addTextField { textField in
          textField.placeholder = "Item name"
      }

      let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
          guard let itemName = alertController.textFields?.first?.text else { return }
          self?.viewStore.send(.addItem(itemName))
      }

      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

      alertController.addAction(addAction)
      alertController.addAction(cancelAction)

      present(alertController, animated: true, completion: nil)
  }

  func editItemAt(index: Int, name: String) {
    let alertController = UIAlertController(title: "Edit Item", message: "Enter item name:", preferredStyle: .alert)
    alertController.addTextField { textField in
        textField.placeholder = "Item name"
        textField.text = name
    }

    let addAction = UIAlertAction(title: "Edit", style: .default) { [weak self] _ in
        guard let itemName = alertController.textFields?.first?.text else { return }
        self?.viewStore.send(.editItem(at: index, item: itemName))
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

    alertController.addAction(addAction)
    alertController.addAction(cancelAction)

    present(alertController, animated: true, completion: nil)
  }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  // MARK: - UICollectionViewDataSource

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewStore.state.items.count// Contoh jumlah item dalam section
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell

    cell.label.text = viewStore.state.items[indexPath.row]
    cell.backgroundColor = randomColor()
    cell.layer.cornerRadius = cell.layer.frame.height / 4
    return cell
  }


  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let index = indexPath.row
    let name = viewStore.state.items[index]
    editItemAt(index: index, name: name)

  }

  // MARK: - UICollectionViewDelegateFlowLayout
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    let text = viewStore.state.items[indexPath.item]
    let font = UIFont.systemFont(ofSize: 17)

    let width = text.width(withConstrainedHeight: 100, font: font) + 20
    return CGSize(width: width + 20 , height: 50)

  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // Atur inset section
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10 // Jarak antar baris
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }

  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

    // Deteksi arah geseran berdasarkan kecepatan (velocity)
    let isDraggingRight = scrollView.contentOffset.x > 10

    // Jika arah geseran ke kanan, sembunyikan gambar pikachu
    if isDraggingRight {
      UIView.animate(withDuration: 0.3) {
        self.pokemonImage.snp.updateConstraints { (make) in
          make.width.equalTo(0)
        }
        self.view.layoutIfNeeded()
        self.pokemonImage.alpha = 0
      }
    } else if scrollView.contentOffset.x < 20 {
      UIView.animate(withDuration: 0.5) {
        self.pokemonImage.snp.updateConstraints { (make) in
          make.width.equalTo(100)
        }
        self.view.layoutIfNeeded()
        self.pokemonImage.alpha = 1
      }
    }
  }
}

extension ViewController {
  func randomColor() -> UIColor {
    let red = CGFloat(arc4random_uniform(256)) / 255.0
    let green = CGFloat(arc4random_uniform(256)) / 255.0
    let blue = CGFloat(arc4random_uniform(256)) / 255.0
    return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
  }
}


class CustomCollectionViewCell: UICollectionViewCell {

  let label: UILabel = {
    let lb = UILabel()
    lb.textColor = .white
    lb.textAlignment = .center
    return lb
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.addSubview(label)
    label.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension String {
  func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
    return ceil(boundingBox.width)
  }
}


class ImageAssetHelper: NSObject {

  static let shared = ImageAssetHelper()

  private override init() {}

  func fetchImage(imageView: UIImageView ) {
    let url = URL(string: "https://app.gemoo.com/share/image-annotation/656194627500945408?codeId=MpmpR4RdWqX62&origin=imageurlgenerator&card=656194623499579392")!
    let placeholderImage = UIImage(named: "pikachu")!
    imageView.af.setImage(withURL: url, placeholderImage: placeholderImage)
  }
}
