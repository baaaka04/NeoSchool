import SnapKit
import UIKit

class CalendarView: UIView {
    weak var delegate: UITextField?
    var toggleCalendarView: ( () -> Void )?

    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        return picker
    }()

    private lazy var clearDateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сбросить", for: .normal)
        button.setTitleColor(.neobisPurple, for: .normal)
        button.titleLabel?.font = AppFont.font(type: .medium, size: 16)
        button.addTarget(self, action: #selector(clearDateTextField), for: .touchUpInside)
        button.titleLabel?.textAlignment = .left
        return button
    }()

    private lazy var confirmDateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.neobisPurple, for: .normal)
        button.titleLabel?.font = AppFont.font(type: .bold, size: 16)
        button.addTarget(self, action: #selector(toggleCalendar), for: .touchUpInside)
        button.titleLabel?.textAlignment = .right
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 10
        self.isHidden = true

        self.setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(10)
        }
        self.addSubview(clearDateButton)
        clearDateButton.snp.makeConstraints { make in
            make.left.equalTo(datePicker)
            make.top.equalTo(datePicker.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
        self.addSubview(confirmDateButton)
        confirmDateButton.snp.makeConstraints { make in
            make.right.equalTo(datePicker)
            make.top.equalTo(datePicker.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
    }

    @objc private func toggleCalendar() {
        self.toggleCalendarView?()
    }

    @objc private func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        self.delegate?.text = dateFormatter.string(from: sender.date)
    }

    @objc private func clearDateTextField() {
        self.delegate?.text = nil
        self.toggleCalendar()
    }
}
