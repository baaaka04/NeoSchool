import UIKit

class GradeView: UIView {
    
    private var gradeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
    }()

    private let subtitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "Jost-Regular", size: 14)
        label.text = "Оценка"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        
        addSubview(gradeLabel)
        
        gradeLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }

        addSubview(subtitle)
        
        subtitle.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }

    func setGrade(grade: Grade, isRounded: Bool) {
        gradeLabel.text = grade.rawValue
        gradeLabel.textColor = isRounded ? .white : grade.color
        
        switch isRounded {
        case true:
            gradeLabel.backgroundColor = grade.color
            gradeLabel.font = UIFont(name: "Jost-SemiBold", size: 20)
            gradeLabel.textColor = .white
            gradeLabel.layer.cornerRadius = 24
        case false:
            gradeLabel.backgroundColor = .neobisGray
            gradeLabel.font = UIFont(name: "Jost-Bold", size: 32)
            gradeLabel.textColor = grade.color
            gradeLabel.layer.cornerRadius = 8
        }
        
    }
}
