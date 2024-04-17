import UIKit
import SnapKit


class AttachedFilesCollectionViewCell : UICollectionViewCell {
    static let identifier = "AttachedFilesCollectionViewCell"
    
    var attachedFile: AttachedFile? {
        didSet {
            titleLabel.text = attachedFile?.name ?? "image 1.jpg"
            imageView.image = attachedFile?.image
        }
    }
    
    weak var delegate: AttachedFilesViewDelegate?
    
    @objc func removeFile() {
        guard let attachedFile else { return }
        delegate?.didTapRemoveFile(file: attachedFile)
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Jost-Medium", size: 20)
        label.textColor = .neobisDarkGray
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Jost-Regular", size: 16)
        label.textColor = .neobisDarkGray
        label.text = "Изображение"
        return label
    }()
    
    let removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor.neobisLightGray
        
        return button
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 1.0
        contentView.layer.masksToBounds = true
        contentView.layer.borderColor = UIColor.neobisGrayStroke.cgColor
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(removeButton)
        
        removeButton.addTarget(self, action: #selector(removeFile), for: .touchUpInside)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.left.width.height.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(72)
            make.left.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(16)
            make.top.equalToSuperview().offset(7)
            make.height.equalTo(26)
        }
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(titleLabel.snp.left)
        }
        removeButton.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
        }
    }
}

protocol AttachedFilesViewDelegate: AnyObject {
    func didTapRemoveFile(file: AttachedFile)
}
