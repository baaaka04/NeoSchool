import SnapKit
import UIKit

class HomeworkClassworkBarView: UIView {
    weak var delegate: ItemsBarDelegate?

    private let label1: SelectableUILabel = {
        let label = SelectableUILabel()
        label.text = "Домашние задания"
        label.ind = 0
        return label
    }()

    private let label2: SelectableUILabel = {
        let label = SelectableUILabel()
        label.text = "Классная работа"
        label.ind = 1
        return label
    }()

    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .neobisPurple
        return view
    }()

    private var selectedLabel: UILabel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        selectLabel(label1)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        selectLabel(label1)
    }

    private func setupViews() {
        [label1, label2, underlineView].forEach { addSubview($0) }

        label1.snp.makeConstraints { $0.left.top.bottom.equalToSuperview() }
        label2.snp.makeConstraints { $0.right.top.bottom.equalToSuperview() }

        label1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:))))
        label2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:))))
    }

    @objc private func labelTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedLabel = sender.view as? SelectableUILabel else { return }
        selectLabel(tappedLabel)
        if let ind = tappedLabel.ind {
            delegate?.didSelectItem(itemId: ind)
        }
    }

    private func selectLabel(_ label: UILabel) {
        selectedLabel?.textColor = .neobisLightGray

        label.textColor = .neobisPurple
        selectedLabel = label

        underlineView.snp.remakeConstraints { make in
            make.left.equalTo(label.snp.left)
            make.width.equalTo(label.snp.width)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}

extension HomeworkClassworkBarView: ItemsBarDelegate {
    func didSelectItem(itemId: Int) {
        if let selectedLabel = [label1, label2].first(where: { $0.ind == itemId }) {
            self.selectLabel(selectedLabel)
        }
    }
}
