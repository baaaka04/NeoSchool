import UIKit

class StudentHomeworkDetailsViewController: DetailTitledViewController {

    var subtitleText: String? {
        didSet { subtitleLabel.text = subtitleText }
    }

    private let subtitleLabel = GrayUILabel(font: AppFont.font(type: .Medium, size: 16))
    private let firstDesciptionLabel = GrayUILabel(font: AppFont.font(type: .Regular, size: 16))
    private let secondDesciptionLabel = GrayUILabel(font: AppFont.font(type: .Regular, size: 16))
    private let inTimeLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .Medium, size: 18)
        label.textColor = .neobisGreen
        return label
    }()

    private let lineView: UIView = {
        let line = UIView()
        line.backgroundColor = .neobisGrayStroke
        return line
    }()
    private let markView = MarkUIView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

}
