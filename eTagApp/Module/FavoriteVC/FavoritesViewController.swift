import UIKit
import SnapKit

class FavoritesViewController: UIViewController {

    let containerView: UIView = {
        let view = UIView()
        return view
    }()

    var views: [UIView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupStackView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateViews()
    }

    func setupStackView() {
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(40)
        }

        for i in 0..<5 {
            let view = UIView()
            view.backgroundColor = self.randomColor()
            view.layer.cornerRadius = 20
            view.layer.borderWidth = 2.0
            view.layer.borderColor = randomColor().cgColor

            containerView.addSubview(view)
            views.append(view)
            view.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
            view.snp.makeConstraints { make in
                make.width.equalTo(40)
                make.top.bottom.equalToSuperview()
                make.leading.equalToSuperview().offset(CGFloat(i * 20)) // Adjusting offset for each view
            }
        }
    }

    func animateViews() {
        for (i, view) in views.enumerated() {
            UIView.animate(withDuration: 0.5, delay: 0.1 * Double(i), options: .curveEaseOut, animations: {
                view.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }

    func randomColor() -> UIColor {
        let red = CGFloat(arc4random_uniform(256)) / 255.0
        let green = CGFloat(arc4random_uniform(256)) / 255.0
        let blue = CGFloat(arc4random_uniform(256)) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
