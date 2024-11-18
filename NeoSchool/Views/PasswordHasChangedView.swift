import SnapKit
import UIKit

class PasswordHasChangedView: UIView {
    private var confirmedAction: (() -> Void)
    private let thumbImage = UIImageView(image: UIImage(named: Asset.thumbUp))

    let modalView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 32
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Пароль успешно обновлён"
        label.textAlignment = .center
        label.font = AppFont.font(type: .medium, size: 22)
        label.textColor = .neobisDarkGray
        return label
    }()

    private lazy var confirmButton: NeobisUIButton = {
        let button = NeobisUIButton(type: .purple)
        button.setTitle("Хорошо", for: .normal)
        button.addTarget(self, action: #selector(onPressConfirm), for: .touchUpInside)
        return button
    }()

    init(confirmedAction: @escaping (() -> Void)) {
        self.confirmedAction = confirmedAction
        super.init(frame: .zero)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onPressConfirm))
        self.addGestureRecognizer(tapGesture)

        addSubview(modalView)

        modalView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(500)
            make.width.equalToSuperview().offset(-32)
        }

        modalView.addSubview(thumbImage)
        modalView.addSubview(titleLabel)
        modalView.addSubview(confirmButton)

        thumbImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(44)
            make.width.height.equalTo(120)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbImage.snp.bottom).offset(Constants.gap)
            make.left.equalToSuperview().offset(Constants.horizantalMargin)
            make.right.equalToSuperview().offset(-Constants.horizantalMargin)
        }
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.gap)
            make.left.equalToSuperview().offset(Constants.horizantalMargin)
            make.right.equalToSuperview().offset(-Constants.horizantalMargin)
            make.height.equalTo(Constants.buttonHeight)
            make.bottom.equalToSuperview().offset(-Constants.horizantalMargin)
        }
    }

    func removeWithAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.modalView.snp.updateConstraints { $0.bottom.equalToSuperview().offset(500) }
            self.layoutIfNeeded()
        } completion: {_  in
            self.removeFromSuperview()
        }
    }

    @objc private func onPressConfirm() {
        confirmedAction()
        removeWithAnimation()
    }

    private struct Constants {
        static let gap: CGFloat = 24
        static let horizantalMargin: CGFloat = 16
        static let buttonHeight: CGFloat = 52
    }
}
