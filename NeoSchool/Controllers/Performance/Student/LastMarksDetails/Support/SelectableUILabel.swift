import UIKit

class SelectableUILabel: UILabel {

    var ind: Int?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        font = AppFont.font(type: .Medium, size: 18)
        textColor = .neobisLightGray
        textAlignment = .center
        isUserInteractionEnabled = true
    }
}

