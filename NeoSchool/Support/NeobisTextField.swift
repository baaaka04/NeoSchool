import UIKit


class NeobisTextField: UITextField {

    override var placeholder: String? {
        didSet {
            guard let placeholder else { return }
            self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.neobisLightGray])
        }
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)

        self.font = AppFont.font(type: .Regular, size: 20)
        self.backgroundColor = .neobisExtralightGray
        self.textColor = .neobisDarkGray
        self.layer.cornerRadius = 16

        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none

        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        if result {
            self.layer.borderColor = UIColor.neobisPurple.cgColor
            self.layer.borderWidth = 1
        }
        return result
    }

    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        if result {
            self.layer.borderWidth = 0
        }
        return result
    }

}

