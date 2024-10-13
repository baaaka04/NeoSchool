import UIKit
import SnapKit

protocol StudentHomeworkProtocol {
    var submissionDetails: TeacherSubmissionDetails? { get set }
    var submissionFilesUrls: [String]? { get set }
    var grade: Grade? { get set }
    func getSubmissionDetails(submissionId: Int) async throws -> Void
    func reviseSubmission(submissionId: Int) async throws -> Void
    func submit(_ submissionId: Int?) async throws -> Void
}

class StudentHomeworkDetailsViewController: DetailTitledViewController, Confirmable, Notifiable {

    enum ScreenSections {
        case generalInfo
        case homeworkInfo
        case mark
        case comments
        case files
    }

    private let sections : [ScreenSections]
    private var submissionId: Int
    private var vm: StudentHomeworkProtocol?
    private let editable: Bool
    var subtitleText: String?

    private let studentFilesVC = FilesCollectionViewController(urls: nil)

    private lazy var reviseButton: NeobisUIButton = {
        let button = NeobisUIButton(type: .white)
        button.setTitle("Вернуть на доработку", for: .normal)
        button.isHidden = !self.editable
        button.addTarget(self, action: #selector(onTapRevise), for: .touchUpInside)
        return button
    }()
    private lazy var gradeButton: NeobisUIButton = {
        let button = NeobisUIButton(type: .purple)
        button.setTitle("Выставить оценку", for: .normal)
        button.isHidden = !self.editable
        button.addTarget(self, action: #selector(openCommentView), for: .touchUpInside)
        return button
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white

        return collectionView
    }()

    init(submissionId: Int, editable: Bool, vm: StudentHomeworkProtocol?) {
        self.submissionId = submissionId
        self.editable = editable
        self.vm = vm
        if editable {
            self.sections = [.generalInfo, .mark, .comments, .files]
        } else {
            self.sections = [.generalInfo, .homeworkInfo, .mark, .files]
        }

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
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        view.addSubview(gradeButton)
        gradeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-52)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(52)
        }
        view.addSubview(reviseButton)
        reviseButton.snp.makeConstraints { make in
            make.bottom.equalTo(gradeButton.snp.top).offset(-12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(52)
        }

        collectionView.register(GeneralInfoCell.self, forCellWithReuseIdentifier: GeneralInfoCell.identifier)
        collectionView.register(HomeworkCell.self, forCellWithReuseIdentifier: HomeworkCell.identifier)
        collectionView.register(MarkInfoCell.self, forCellWithReuseIdentifier: MarkInfoCell.identifier)
        collectionView.register(CommentsCell.self, forCellWithReuseIdentifier: CommentsCell.identifier)
        collectionView.register(FilesCell.self, forCellWithReuseIdentifier: FilesCell.identifier)
    }


    private func getSubmissionDetails() {
        Task {
            do {
                try await vm?.getSubmissionDetails(submissionId: self.submissionId)

                if let submissionFilesUrls = vm?.submissionFilesUrls {
                    studentFilesVC.update(urls: submissionFilesUrls)
                }

                if vm?.submissionDetails?.canChangeMark ?? false {
                    self.reviseButton.isHidden = true
                    self.gradeButton.type = .white
                    self.gradeButton.setTitle("Изменить оценку", for: .normal)
                } else {
                    self.gradeButton.type = .purple
                    self.gradeButton.setTitle("Выставить оценку", for: .normal)
                }

                self.collectionView.reloadData()
            } catch { print(error) }
        }
    }

    @objc private func onTapRevise() {
        self.showConfirmView(title: "Вернуть задание на доработку?", text: "Ученику придет уведомление, что его задание должно быть доработано", confirmButtonText: "Вернуть на доработку", declineButtonText: "Отмена", confirmedAction: {[weak self] in
            guard let strongSelf = self else { return }
            Task {
                do {
                    try await strongSelf.vm?.reviseSubmission(submissionId: strongSelf.submissionId)
                    strongSelf.showNotification(message: "Отправлено на доработку", isSucceed: true)
                } catch {
                    print(error)
                    strongSelf.showNotification(message: "Произошла ошибка", isSucceed: false)
                }
                strongSelf.getSubmissionDetails()
            }
        })
    }

    @objc private func openCommentView() {
        let commentVC = CommentModalViewController(type: .teacherWithComment, submissionId: self.submissionId)
        commentVC.delegate = self.vm as? CommentRepresentableProtocol
        commentVC.getLessonDetails = { [weak self] in
            self?.getSubmissionDetails()
        }
        commentVC.modalPresentationStyle = .overFullScreen
        self.present(commentVC, animated: false)
    }

}

extension StudentHomeworkDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let section = sections[indexPath.item]

        switch section {
        case .generalInfo:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GeneralInfoCell.identifier, for: indexPath) as? GeneralInfoCell

            if let submission: TeacherSubmissionDetails = vm?.submissionDetails {
                cell?.subtitleText = self.subtitleText
                cell?.firstDesciptionText = "\(submission.topic) · Предмет: \(submission.subject.name)"
                cell?.secondDesciptionText = submission.submittedDate
                cell?.onTimeText = submission.submittedOnTime ? "Прислано в срок" : "Срок сдачи пропущен"
            }

            return cell ?? UICollectionViewCell()
        case .homeworkInfo:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeworkCell.identifier, for: indexPath) as? HomeworkCell

            if let submission = vm?.submissionDetails {
                cell?.updateUI(submission: submission)
            }

            return cell ?? UICollectionViewCell()
        case .mark:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarkInfoCell.identifier, for: indexPath) as? MarkInfoCell

            if let submission = vm?.submissionDetails {
                cell?.mark = Grade(rawValue: submission.mark ?? "-")
            }

            return cell ?? UICollectionViewCell()
        case .comments:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentsCell.identifier, for: indexPath) as? CommentsCell

            if let submission = vm?.submissionDetails {
                cell?.studentCommentText = submission.studentComment
                cell?.updateTeacherComment(text: submission.teacherComment)
            }

            return cell ?? UICollectionViewCell()
        case .files:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilesCell.identifier, for: indexPath) as? FilesCell

            //addSubview only if the parent doesn't have one
            if let _ = cell?.contentView.subviews.first {
                if let submission = vm?.submissionDetails {

                    let filesCount = submission.files.count
                    studentFilesVC.view.snp.makeConstraints { make in
                        //picHeight = 64; picMargin = 8; bottomMargin = 168
                        make.height.equalTo(filesCount > 0 ? (64*filesCount+(filesCount-1)*8+168) : 0)
                    }
                }
            } else {
                cell?.contentView.addSubview(studentFilesVC.view)

                studentFilesVC.view.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }

            return cell ?? UICollectionViewCell()
        }

    }

}
