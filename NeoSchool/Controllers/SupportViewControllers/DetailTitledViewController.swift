import UIKit
import SnapKit

class DetailTitledViewController: DetailViewController {

    var titleText: String? {
        didSet { titleLabel.text = titleText }
    }
    let titleLabel = GrayUILabel(font: AppFont.font(type: .SemiBold, size: 28))

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(titleLabel)
        titleLabel.text = titleText
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.right.equalToSuperview().inset(16)
        }
    }

}
