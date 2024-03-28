import UIKit
import SnapKit

class SubjectDetailsViewController: UIViewController {
    
    let viewModel: SubjectDetailsViewModelRepresentable
    
    let homeworkPanel = HomeworkPanelViewController()
    
    lazy var titleLabel: GrayUILabel = {
        let titleLabel = GrayUILabel()
        titleLabel.font = UIFont(name: "Jost-SemiBold", size: 28)
        return titleLabel
    }()
    
    lazy var firstSubTitleLabel: GrayUILabel = {
        let firstSubTitleLabel = GrayUILabel()
        firstSubTitleLabel.font = UIFont(name: "Jost-Regular", size: 16)
        return firstSubTitleLabel
    }()
    
    lazy var secondSubTitleLabel: GrayUILabel = {
        let secondSubTitleLabel = GrayUILabel()
        secondSubTitleLabel.font = UIFont(name: "Jost-Regular", size: 16)
        return secondSubTitleLabel
    }()
    
    lazy var deadlineLabel: UILabel = {
        let deadlineLabel = UILabel(frame: .infinite)
        deadlineLabel.textAlignment = .right
        deadlineLabel.textColor = UIColor.neobisPurple
        deadlineLabel.font = UIFont(name: "Jost-Medium", size: 18)
        return deadlineLabel
    }()
    
    lazy var markLabel: GrayUILabel = {
        let markLabel = GrayUILabel()
        markLabel.font = UIFont(name: "Jost-Regular", size: 20)
        return markLabel
    }()


    init(viewModel: SubjectDetailsViewModelRepresentable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(firstSubTitleLabel)
        view.addSubview(secondSubTitleLabel)
        self.addChild(homeworkPanel)
        view.addSubview(homeworkPanel.view)
        view.addSubview(deadlineLabel)
        view.addSubview(markLabel)
        
        setupConstraints()
        
        fillLabelsWithData()
        getLessonDetails()
        
        setupButtonsUI()
    }
    
    private func getLessonDetails() {
        Task {
            try await viewModel.getLessonDetailData()
            fillLabelsWithData()
        }
    }
    private func setupButtonsUI () {
        let uploadButton = UIButton()
        uploadButton.setTitle("Отправить задание", for: .normal)
        uploadButton.backgroundColor = .neobisLightPurple
        uploadButton.layer.cornerRadius = 16
        uploadButton.titleLabel?.font = UIFont(name: "Jost-Regular", size: 20)
        
        view.addSubview(uploadButton)
        
        uploadButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().offset(-52)
        }
        
        let addFilesButton = UIButton()
        addFilesButton.backgroundColor = .white
        addFilesButton.layer.cornerRadius = 16
        addFilesButton.layer.borderWidth = 1.0
        addFilesButton.layer.borderColor = UIColor.neobisPurple.cgColor
        
        let plusIcon = UIImage(systemName: "plus.circle")?.withTintColor(.neobisPurple, renderingMode: .alwaysOriginal)
        addFilesButton.setImage(plusIcon, for: .normal)
        addFilesButton.setTitle(" Прикрепить файлы", for: .normal)
        addFilesButton.setTitleColor(.neobisPurple, for: .normal)
        addFilesButton.titleLabel?.font = UIFont(name: "Jost-Regular", size: 20)
        
        let openMediaAction = UIAction(title: "Медиатека") { _ in print("Медиатека was tapped") }
        let takePhotoAction = UIAction(title: "Снять фото или видео") { _ in print("Снять фото или видео was tapped") }
        let selectFilesAction = UIAction(title: "Выбор файлов") { _ in print("Выбор файлов was tapped") }
        
        let menu = UIMenu(options: .displayInline, children: [openMediaAction , takePhotoAction , selectFilesAction])
        addFilesButton.menu = menu
        addFilesButton.showsMenuAsPrimaryAction = true

        view.addSubview(addFilesButton)
        
        addFilesButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.height.equalTo(52)
            make.bottom.equalTo(uploadButton.snp.top).offset(-12)
        }
    }
    
    private func fillLabelsWithData() {
        titleLabel.text = viewModel.subjectName
        firstSubTitleLabel.attributedText = viewModel.teacherName
        secondSubTitleLabel.attributedText = viewModel.homeworkTopic
        deadlineLabel.text = viewModel.homeworkDeadline
        markLabel.attributedText = viewModel.homeworkMark
        
        homeworkPanel.homeworkText = viewModel.homeworkText ?? "Не задано"
    }
        
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.top.equalToSuperview().offset(112)
        }
        firstSubTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.top.equalTo(titleLabel.snp.bottom)
        }
        secondSubTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.top.equalTo(firstSubTitleLabel.snp.bottom)
        }
        homeworkPanel.view.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-32)
            make.height.equalTo(112)
            make.centerX.equalToSuperview()
            make.top.equalTo(secondSubTitleLabel.snp.bottom).offset(16)
        }
        deadlineLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.top.equalTo(homeworkPanel.view.snp.bottom).offset(16)
        }
        markLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.top.equalTo(deadlineLabel.snp.bottom).offset(16)
        }
        homeworkPanel.didMove(toParent: self)
        
    }
    
}
