import UIKit

class PlaceholderTextView: UITextView {

    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
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
}
