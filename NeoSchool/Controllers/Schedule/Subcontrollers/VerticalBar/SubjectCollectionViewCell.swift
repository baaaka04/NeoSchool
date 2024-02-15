import UIKit
import SnapKit

class SubjectCollectionViewCell: UICollectionViewCell {
    static let identifier = "SubjectCollectionViewCell"
    
    var id: Int = 0
    var title: String? {
        didSet {
            titleLabel.text = "\(id). \(title ?? "")"
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Jost-Medium", size: 20)
        label.textColor = .black
        return label
    }()
    
    var subtitle: String? {
        didSet {
            subtitleLabel.text = subtitle
        }
    }
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Jost-Regular", size: 16)
        label.textColor = .black
        return label
    }()
    
    var descr: String? {
        didSet {
            descrLabel.text = descr
        }
    }
    
    private let descrLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Jost-MediumItalic", size: 16)
        label.textColor = .neobisBlue
        return label
    }()
    
    private var gradeView = GradeView()
    func setGrade(to grade: Grade) {
        self.gradeView.setGrade(grade: grade, isRounded: false)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI () {
        contentView.backgroundColor = .clear
        contentView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
        }
        
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        addSubview(descrLabel)
        descrLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(subtitleLabel.snp.bottom)
        }
        
        addSubview(gradeView)
        gradeView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(72)
            make.width.equalTo(48)
        }
    }
       
    
}
