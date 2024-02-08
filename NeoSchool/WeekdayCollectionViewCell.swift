import UIKit

struct Weekday {
    let name: String
    let lessonsAmount: Int
}

class WeekdayCollectionViewCell: UICollectionViewCell {
    static let identifier = "WeekdayCollectionViewCell"
            
    private var weekdayLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Jost-Bold", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let schoolDay : Weekday = .init(name: "ПН", lessonsAmount: 6)
//    let schoolWeek = [
//        Weekday(name: "пн", lessonsAmount: 5),
//        Weekday(name: "вт", lessonsAmount: 4),
//        Weekday(name: "ср", lessonsAmount: 5),
//        Weekday(name: "чт", lessonsAmount: 6),
//        Weekday(name: "пт", lessonsAmount: 6),
//        Weekday(name: "сб", lessonsAmount: 3),
//    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let firstLineLabel = "\(schoolDay.name)"
        let secondLineLabel = "\(schoolDay.lessonsAmount) уроков"
        let labelText = "\(firstLineLabel)\n\(secondLineLabel)"
        
        let firstLineFont = UIFont(name: "Jost-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16)
        let secondLineFont = UIFont(name: "Jost-SemiBold", size: 12) ?? UIFont.systemFont(ofSize: 12)
        
        let attributedText = NSMutableAttributedString(string: labelText)
        attributedText.addAttribute(.font, value: firstLineFont, range: NSRange(location: 0, length: firstLineLabel.count))
        attributedText.addAttribute(.font, value: secondLineFont, range: NSRange(location: firstLineLabel.count + 1, length: secondLineLabel.count))
        
        weekdayLabel.text = "\(firstLineLabel)\n\(secondLineLabel)"
        weekdayLabel.attributedText = attributedText
        
        contentView.addSubview(weekdayLabel)
        
        weekdayLabel.snp.makeConstraints { make in
            make.height.width.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
