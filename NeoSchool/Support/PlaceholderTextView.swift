import UIKit

class PlaceholderTextView: UITextView {

    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.neobisLightGray
        label.numberOfLines = 0
        return label
    }()
    
    lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()

    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    var counter: String? {
        didSet {
            counterLabel.text = counter
        }
    }
    
    var limit: Int? {
        didSet {
            counterLabel.text = "0/\(limit ?? 0)"
        }
    }

    var placeholderInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 6, bottom: 8, right: 6) {
        didSet {
            setNeedsLayout()
        }
    }
    
    var counterInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 6, bottom: 8, right: 6) {
        didSet {
            setNeedsLayout()
        }
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addSubview(placeholderLabel)
        addSubview(counterLabel)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
        
        let constraints = [
            self.counterLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.counterLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.textContainerInset = padding

        self.placeholderLabel.font = AppFont.font(type: .Regular, size: 20)
        self.counterLabel.font = AppFont.font(type: .Regular, size: 12)
        self.counterLabel.textAlignment = .right
        self.layer.cornerRadius = 16
        self.font = AppFont.font(type: .Regular, size: 18)
        self.backgroundColor = UIColor.neobisExtralightGray
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.frame = bounds.inset(by: placeholderInsets)
        counterLabel.frame = bounds.inset(by: counterInsets)
        placeholderLabel.isHidden = !text.isEmpty
    }

    @objc private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
        guard let limit else {return}
        if self.text.count > limit {
            self.text = String(self.text.prefix(limit))
        }
        counterLabel.text = "\(self.text.count)/\(limit)"
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
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
