import UIKit

class SelectableUILabel: UILabel {
    var ind: Int?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        font = AppFont.font(type: .medium, size: 18)
        textColor = .neobisLightGray
        textAlignment = .center
        isUserInteractionEnabled = true
    }
}
