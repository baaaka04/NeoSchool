import UIKit
import SnapKit

protocol StudentHomeworkProtocol {
    var submissionDetails: TeacherSubmissionDetails? { get set }
    func getSubmissionDetails(submissionId: Int) async throws -> Void
}

class StudentHomeworkDetailsViewController: DetailTitledViewController {

    private var submissionId: Int
    private var vm: StudentHomeworkProtocol?
    var subtitleText: String? {
        didSet { subtitleLabel.text = subtitleText }
    }

    private let subtitleLabel = GrayUILabel(font: AppFont.font(type: .Medium, size: 16))
    private let firstDesciptionLabel = GrayUILabel(font: AppFont.font(type: .Regular, size: 16))
    private let secondDesciptionLabel = GrayUILabel(font: AppFont.font(type: .Regular, size: 16))
    private let inTimeLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(type: .Medium, size: 18)
        label.textColor = .neobisGreen
        return label
    }()

    private let lineView: UIView = {
        let line = UIView()
        line.backgroundColor = .neobisGrayStroke
        return line
    }()
    private let markView = MarkUIView()

    init(submissionId: Int, vm: StudentHomeworkProtocol?) {
        self.submissionId = submissionId
        self.vm = vm

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


        setupUI()
        getSubmissionDetails()
    }
    
    private func setupUI() {
        view.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalTo(titleLabel)
        }
    }

    private func updateUI() {

    }

    private func getSubmissionDetails() {
        Task {
            do {
                try await vm?.getSubmissionDetails(submissionId: self.submissionId)
                updateUI()
            } catch { print(error) }
        }
    }

}
