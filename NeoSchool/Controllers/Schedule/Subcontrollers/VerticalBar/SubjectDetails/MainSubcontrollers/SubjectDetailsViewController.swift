import UIKit
import SnapKit

class SubjectDetailsViewController: DetailViewController {
    
    //MARK: - Properties
    
    let viewModel: SubjectDetailsViewModelRepresentable
    let homeworkPanel = HomeworkPanelViewController()
    var getLessonDetails: ( () -> Void)?
    
    lazy var scrollView = UIScrollView()
    let markLabel = MarkUIView()
    
    lazy var titleLabel: GrayUILabel = {
        let titleLabel = GrayUILabel()
        titleLabel.font = AppFont.font(type: .SemiBold, size: 28)
        return titleLabel
    }()
    
    lazy var firstSubTitleLabel: GrayUILabel = {
        let firstSubTitleLabel = GrayUILabel()
        firstSubTitleLabel.font = AppFont.font(type: .Regular, size: 16)
        return firstSubTitleLabel
    }()
    
    lazy var secondSubTitleLabel: GrayUILabel = {
        let secondSubTitleLabel = GrayUILabel()
        secondSubTitleLabel.font = AppFont.font(type: .Regular, size: 16)
        return secondSubTitleLabel
    }()
    
    lazy var deadlineLabel: UILabel = {
        let deadlineLabel = UILabel(frame: .infinite)
        deadlineLabel.textAlignment = .right
        deadlineLabel.textColor = UIColor.neobisPurple
        deadlineLabel.font = AppFont.font(type: .Medium, size: 18)
        return deadlineLabel
    }()
        
    //MARK: - Initializers
    
    init(viewModel: SubjectDetailsViewModelRepresentable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(firstSubTitleLabel)
        scrollView.addSubview(secondSubTitleLabel)
        setupHomeworkUI()
        scrollView.addSubview(deadlineLabel)
        scrollView.addSubview(markLabel)
    }

    func setupHomeworkUI () {
        self.addChild(homeworkPanel)
        scrollView.addSubview(homeworkPanel.view)
        homeworkPanel.didMove(toParent: self)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapHomework))
        homeworkPanel.view.addGestureRecognizer(tapGesture)
    }
            
    @objc func onTapHomework() {
        let attachedListVC = AttachedFilesDetailViewController(viewModel: self.viewModel)
        attachedListVC.title = "Прикрепленные материалы"
        
        self.navigationController?.pushViewController(attachedListVC, animated: true)
    }
    
    @objc func didTapBackButton () {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
        
    //MARK: - Constraints
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.horizontalMargin)
            make.top.equalToSuperview()
        }
        firstSubTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.horizontalMargin)
            make.top.equalTo(titleLabel.snp.bottom)
        }
        secondSubTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.horizontalMargin)
            make.top.equalTo(firstSubTitleLabel.snp.bottom)
        }
        homeworkPanel.view.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-Constants.horizontalMargin)
            make.height.equalTo(142)
            make.centerX.equalToSuperview()
            make.top.equalTo(secondSubTitleLabel.snp.bottom).offset(Constants.gap)
        }
        deadlineLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.horizontalMargin)
            make.top.equalTo(homeworkPanel.view.snp.bottom).offset(Constants.gap)
        }
        markLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.horizontalMargin)
            make.top.equalTo(deadlineLabel.snp.bottom).offset(Constants.gap)
        }
    }
    
    struct Constants {
        static let commentHeight: CGFloat = 374
        static let horizontalMargin: CGFloat = 32
        static let gap: CGFloat = 16
    }
    
}
