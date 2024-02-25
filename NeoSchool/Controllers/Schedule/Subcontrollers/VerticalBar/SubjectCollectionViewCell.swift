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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Jost-Medium", size: 20)
        label.textColor = .black
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
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
            make.width.height.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        addSubview(gradeView)
        let gradeViewWidth = CGFloat(48)
        let gradeViewLeftMargin = CGFloat(16)
        gradeView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(72)
            make.width.equalTo(gradeViewWidth)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.width.equalToSuperview().inset( (gradeViewWidth + gradeViewLeftMargin) / 2 )
        }
        
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.height.equalTo(23)
        }
        
        addSubview(descrLabel)
        descrLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(subtitleLabel.snp.bottom).offset(4)
            make.height.equalTo(20)
        }
        
    }
       
    
}

extension SubjectCollectionViewCell {
    class func getProductHeightForWidth(title: String, font: UIFont, minHeight: CGFloat, width: CGFloat) -> CGFloat {
      var resultingHeight: CGFloat = minHeight
      let titleHeight = title.getHeight(font: font, width: width)
      resultingHeight += titleHeight
      return resultingHeight
  }
}
