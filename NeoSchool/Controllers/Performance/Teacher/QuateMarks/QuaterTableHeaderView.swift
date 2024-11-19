import UIKit

class QuaterTableHeaderView: UIStackView {
    private let columnOneLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .regular, size: 16)
        label.textColor = .neobisLightGray
        label.text = "Фамилия и имя"
        return label
    }()

    private let columnTwoView = UIStackView()

    init() {
        super.init(frame: .zero)

        setupUI()
    }

    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        [columnOneLabel, columnTwoView].forEach { addArrangedSubview($0) }

        axis = .horizontal
        distribution = .fillEqually
        columnTwoView.axis = .horizontal
        columnTwoView.distribution = .fillEqually

        let numbers = ["I", "II", "III", "IV", "Год"]
        numbers.forEach {
            let label = UILabel()
            label.text = $0
            label.font = AppFont.font(type: .regular, size: 16)
            label.textColor = .neobisLightGray
            label.textAlignment = .center
            columnTwoView.addArrangedSubview(label)
        }
    }
}
