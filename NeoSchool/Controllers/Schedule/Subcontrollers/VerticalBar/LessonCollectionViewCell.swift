import UIKit
import SnapKit

class LessonCollectionViewCell: UICollectionViewCell {
        
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    private let titleLabel: GrayUILabel = {
        let label = GrayUILabel()
        label.font = AppFont.font(type: .Medium, size: 20)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var subtitle: String? {
        didSet {
            subtitleLabel.text = subtitle
        }
    }
    
    let subtitleLabel: GrayUILabel = {
        let label = GrayUILabel()
        label.font = AppFont.font(type: .Regular, size: 16)
        return label
    }()
    
    
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
            make.width.equalToSuperview().inset(16)
            make.centerX.height.equalToSuperview()
        }

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
    }
       
    
}

extension LessonCollectionViewCell {
    class func getCellHeightForWidth(title: String, font: UIFont, minHeight: CGFloat, width: CGFloat) -> CGFloat {
      var resultingHeight: CGFloat = minHeight
      let titleHeight = title.getHeight(font: font, width: width)
      resultingHeight += titleHeight
      return resultingHeight
  }
}
