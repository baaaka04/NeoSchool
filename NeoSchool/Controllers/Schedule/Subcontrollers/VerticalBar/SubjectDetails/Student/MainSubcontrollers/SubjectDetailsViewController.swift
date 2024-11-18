import SnapKit
import UIKit

class SubjectDetailsViewController: DetailViewController {
    // MARK: - Properties

    let viewModel: SubjectDetailsViewModelRepresentable
    let homeworkPanel = HomeworkPanelView(presentaionMode: .student)
    var getLessonDetails: ( () -> Void)?

    lazy var scrollView = UIScrollView()
    let markLabel = MarkUIView()

    let titleLabel: GrayUILabel = {
        let titleLabel = GrayUILabel()
        titleLabel.font = AppFont.font(type: .semiBold, size: 28)
        return titleLabel
    }()

    let firstSubTitleLabel: GrayUILabel = {
        let firstSubTitleLabel = GrayUILabel()
        firstSubTitleLabel.font = AppFont.font(type: .regular, size: 16)
        return firstSubTitleLabel
    }()

    let secondSubTitleLabel: GrayUILabel = {
        let secondSubTitleLabel = GrayUILabel()
        secondSubTitleLabel.font = AppFont.font(type: .regular, size: 16)
        return secondSubTitleLabel
    }()

    let deadlineLabel: UILabel = {
        let deadlineLabel = UILabel(frame: .infinite)
        deadlineLabel.textAlignment = .right
        deadlineLabel.textColor = UIColor.neobisPurple
        deadlineLabel.font = AppFont.font(type: .medium, size: 18)
        return deadlineLabel
    }()

    // MARK: - Initializers

    init(viewModel: SubjectDetailsViewModelRepresentable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI setup

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
        scrollView.addSubview(homeworkPanel)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapHomework))
        homeworkPanel.addGestureRecognizer(tapGesture)
        homeworkPanel.attachedFilesLabel.addTarget(self, action: #selector(onTapHomework), for: .touchUpInside)
    }

    @objc func onTapHomework() {
        let attachedListVC = AttachedFilesDetailViewController(URLs: viewModel.homeworkFileURLs)
        attachedListVC.title = "Прикрепленные материалы"

        self.navigationController?.pushViewController(attachedListVC, animated: true)
    }

    @objc func didTapBackButton () {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Constraints

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
        homeworkPanel.snp.makeConstraints { make in
            make.top.equalTo(secondSubTitleLabel.snp.bottom).offset(Constants.gap)
            make.right.left.equalTo(secondSubTitleLabel)
        }
        deadlineLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-Constants.horizontalMargin)
            make.top.equalTo(homeworkPanel.snp.bottom).offset(Constants.gap)
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
