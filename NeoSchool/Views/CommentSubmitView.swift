import UIKit
import SnapKit

enum CommentType {
    case studentWithComment, teacherWithComment, teacherWithoutComment
}

class CommentSubmitView: UIStackView {

    var uploadFiles: (() -> Void)?
    var selectedGrade: Grade?

    private let titleLabel: UILabel = {
        let label = GrayUILabel()
        label.font = AppFont.font(type: .Medium, size: 22)
        label.textAlignment = .center
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = GrayUILabel()
        label.text = "Выберите одну из оценок:"
        label.font = AppFont.font(type: .Regular, size: 18)
        label.textAlignment = .center
        return label
    }()

    let commentInput: PlaceholderTextView = {
        let input = PlaceholderTextView()
        input.placeholder = "Комментарий (необязательно)"
        input.placeholderInsets = UIEdgeInsets(top: 12, left: 16, bottom: Constants.inputHeight-34, right: 16)
        input.counterInsets = UIEdgeInsets(top: Constants.inputHeight-34, left: 16, bottom: 12, right: 16)
        input.limit = 100
        return input
    }()

    private var submitButton = NeobisUIButton(type: .purple)

    private let grabber: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4
        imageView.backgroundColor = .neobisExtralightGray
        return imageView
    }()

    private let buttonSetView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 10
        stack.distribution = .equalSpacing
        return stack
    }()

    private var buttonValues: [Grade]
    private var buttons: [GradeUIButton] = []

    private struct Constants {
        static let gap: CGFloat = 24
        static let horizontalPadding: CGFloat = 32
        static let inputHeight: CGFloat = 158
    }

    //MARK: - Initializers
    init(type: CommentType) {

        switch type {
        case .teacherWithComment:
            self.titleLabel.text = "Оценка за задание"
            self.buttonValues = [.two, .three, .four, .five]
            self.submitButton.isEnabled = false
            self.submitButton.setTitle("Выставить оценку", for: .normal)
        case .studentWithComment:
            self.titleLabel.text = "Сдать задание"
            self.buttonValues = [.two, .three, .four, .five]
            self.submitButton.setTitle("Сдать", for: .normal)
            self.subtitleLabel.isHidden = true
            self.buttonSetView.isHidden = true
        case .teacherWithoutComment:
            self.titleLabel.text = "Оценка за урок"
            self.buttonValues = [.absent, .two, .three, .four, .five]
            self.submitButton.isEnabled = false
            self.commentInput.isHidden = true
            self.submitButton.setTitle("Выставить оценку", for: .normal)
        }

        super.init(frame: .zero)

        self.submitButton.addTarget(self, action: #selector(uploadFilesButtonTapped), for: .touchUpInside)
        setupUI()
        setupButtonsUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - UI functions
    private func setupUI () {

        addArrangedSubview(grabber)
        addArrangedSubview(titleLabel)
        addArrangedSubview(subtitleLabel)
        addArrangedSubview(buttonSetView)
        addArrangedSubview(commentInput)
        addArrangedSubview(submitButton)

        layer.cornerRadius = 32
        backgroundColor = .white

        axis = .vertical
        spacing = 12
        alignment = .center
        distribution = .equalSpacing
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 34, right: 0)

        grabber.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.1)
            make.height.equalTo(6)
        }
        buttonSetView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalToSuperview().offset(-70)
        }
        commentInput.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-Constants.horizontalPadding)
            make.height.equalTo(Constants.inputHeight)
        }
        submitButton.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-Constants.horizontalPadding)
            make.height.equalTo(52)
        }
    }

    func setupButtonsUI() {
        for value in buttonValues {
            let button = GradeUIButton()
            button.grade = value

            button.setTitle(value.rawValue, for: .normal)
            button.setTitleColor(.neobisLightGray, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.titleLabel?.font = AppFont.font(type: .SemiBold, size: 24)
            button.backgroundColor = .neobisExtralightGray
            button.layer.cornerRadius = 8

            buttons.append(button)
            buttonSetView.addArrangedSubview(button)

            button.snp.makeConstraints { make in
                make.width.equalTo(buttonSetView.snp.height)
                make.height.equalToSuperview()
            }

            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
    }

    //MARK: - Action functions
    @objc func buttonTapped(_ sender: GradeUIButton) {
        // Loop through all buttons and reset their background color to gray
        for button in buttons {
            button.backgroundColor = .neobisExtralightGray
            button.isSelected = false
        }
        // Set the tapped button's background color and mark it as selected
        sender.backgroundColor = sender.grade?.color
        sender.isSelected = true
        self.submitButton.isEnabled = true
        self.selectedGrade = sender.grade
    }

    @objc func uploadFilesButtonTapped() {
        uploadFiles?()
    }
}

class GradeUIButton: UIButton {
    var grade: Grade?
}
