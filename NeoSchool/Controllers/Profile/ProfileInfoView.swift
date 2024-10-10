import UIKit
import SnapKit


class ProfileInfoView: ContainerView {
    
    private let profileInfo: ProfileInfo
    
    private let userTitleLabel = UILabel()
    private let userFullName = GrayUILabel(font: AppFont.font(type: .Regular, size: 18))
    private let userEmail = GrayUILabel(font: AppFont.font(type: .Regular, size: 18))
    
    private let schoolTitleLabel = UILabel()
    private let schoolNameLabel = GrayUILabel(font: AppFont.font(type: .Regular, size: 18))
    private let mainClassLabel = GrayUILabel(font: AppFont.font(type: .Regular, size: 18))
    private let otherInfoLabel = GrayUILabel(font: AppFont.font(type: .Regular, size: 18))
    
    init(profileInfo: ProfileInfo) {
        self.profileInfo = profileInfo
        super.init(frame: .zero)
        fillUpWithData()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fillUpWithData() {
        self.userTitleLabel.text = switch profileInfo.role {
            case .student: "Об ученике"
            case .teacher: "Об учителе"
        }
        self.userFullName.text = profileInfo.userFullName
        self.userEmail.text = profileInfo.userEmail
        self.schoolNameLabel.text = profileInfo.userSchoolName
        self.mainClassLabel.text = profileInfo.userMainClass
        self.otherInfoLabel.text = profileInfo.userOtherInfo
    }

    private func setupUI() {
                        
        userTitleLabel.textColor = .neobisGreen
        userTitleLabel.font = AppFont.font(type: .SemiBold, size: 20)
        
        schoolTitleLabel.textColor = .neobisGreen
        schoolTitleLabel.font = AppFont.font(type: .SemiBold, size: 20)
        schoolTitleLabel.text = "О школе"
        
        let FIOTitleLabel = GrayUILabel(font: AppFont.font(type: .Medium, size: 18))
        FIOTitleLabel.text = "ФИО"
        let emailTitleLabel = GrayUILabel(font: AppFont.font(type: .Medium, size: 18))
        emailTitleLabel.text = "Электронная почта"
        let schoolNameTitleLabel = GrayUILabel(font: AppFont.font(type: .Medium, size: 18))
        schoolNameTitleLabel.text = "Наименование"
        let mainClassTitleLabel = GrayUILabel(font: AppFont.font(type: .Medium, size: 18))
        mainClassTitleLabel.text = switch profileInfo.role {
        case .student: "Класс"
        case .teacher: "Классное руководство"
        }
        let otherInfoTitleLabel = GrayUILabel(font: AppFont.font(type: .Medium, size: 18))
        otherInfoTitleLabel.text = switch profileInfo.role {
        case .student: "Классный руководитель"
        case .teacher: "Другие классы"
        }
        
        let lineImage = UIView()
        lineImage.backgroundColor = .neobisGrayStroke
        
        [userTitleLabel, FIOTitleLabel, userFullName, emailTitleLabel, userEmail, lineImage, schoolTitleLabel, schoolNameTitleLabel, schoolNameLabel, mainClassTitleLabel, mainClassLabel, otherInfoTitleLabel, otherInfoLabel].forEach { addSubview($0) }

        userTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.sectionGap)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.padding*2)
        }
        FIOTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(userTitleLabel.snp.bottom).offset(Constants.sectionGap)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.padding*2)
        }
        userFullName.snp.makeConstraints { make in
            make.top.equalTo(FIOTitleLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.padding*2)
        }
        emailTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(userFullName.snp.bottom).offset(Constants.sectionGap)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.padding*2)
        }
        userEmail.snp.makeConstraints { make in
            make.top.equalTo(emailTitleLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.padding*2)
        }
        lineImage.snp.makeConstraints { make in
            make.top.equalTo(userEmail.snp.bottom).offset(Constants.sectionGap)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalToSuperview().offset(-Constants.padding*2)
        }
        schoolTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(lineImage.snp.bottom).offset(Constants.sectionGap)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.padding*2)
        }
        schoolNameTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(schoolTitleLabel.snp.bottom).offset(Constants.sectionGap)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.padding*2)
        }
        schoolNameLabel.snp.makeConstraints { make in
            make.top.equalTo(schoolNameTitleLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.padding*2)
        }
        mainClassTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(schoolNameLabel.snp.bottom).offset(Constants.sectionGap)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.padding*2)
        }
        mainClassLabel.snp.makeConstraints { make in
            make.top.equalTo(mainClassTitleLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.padding*2)
        }
        otherInfoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainClassLabel.snp.bottom).offset(Constants.sectionGap)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.padding*2)
        }
        otherInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(otherInfoTitleLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.padding*2)
            make.bottom.equalToSuperview().inset(Constants.sectionGap)
        }
    }
    
    struct Constants {
        static let padding: CGFloat = 16
        static let sectionGap: CGFloat = 12
    }
    
}
