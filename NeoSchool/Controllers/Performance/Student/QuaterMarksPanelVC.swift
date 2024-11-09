import UIKit
import SnapKit

class QuaterMarksPanelVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private let performanceAPI: PerformanceAPIProtocol

    private var lastMarks: [LastMarks?] = []
    private lazy var lastMarksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SubjectLastMarksCell.self, forCellWithReuseIdentifier: SubjectLastMarksCell.identifier)
        return collectionView
    }()

    private let emptyView = NotepadView(title: "Данных пока нет", subtitle: "Мы оповестим вас, когда оценки за II четверть будут доступны в приложении")

    init(performanceAPI: PerformanceAPIProtocol) {
        self.performanceAPI = performanceAPI

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        let containerView = ContainerView()
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(view.frame.size.width-32)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        containerView.addSubview(lastMarksCollectionView)
        lastMarksCollectionView.snp.makeConstraints { make in
            make.height.equalTo(350)
            make.top.bottom.equalToSuperview().inset(12)
            make.left.right.equalToSuperview().inset(16)
        }
        containerView.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(22)
            make.left.right.equalToSuperview().inset(56)
        }
    }

    private func getQuaterLastMarks(quater: String) {
        Task {
            self.lastMarks = try await performanceAPI.getLastMarks(quater: quater)
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }

    private func updateUI() {
        lastMarksCollectionView.reloadData()
        lastMarksCollectionView.snp.updateConstraints { make in
            if !lastMarks.isEmpty {
                make.height.equalTo(lastMarks.count*92+(lastMarks.count-1)*16+24)
            } else {
                make.height.equalTo(350)
            }
        }
        lastMarksCollectionView.isHidden = lastMarks.isEmpty
        emptyView.isHidden = !lastMarks.isEmpty
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        lastMarks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = lastMarksCollectionView.dequeueReusableCell(withReuseIdentifier: SubjectLastMarksCell.identifier, for: indexPath) as? SubjectLastMarksCell,
              let subjectLastMarks = lastMarks[indexPath.row]
        else { return UICollectionViewCell() }

        cell.titleText = subjectLastMarks.name
        cell.quaterMark = subjectLastMarks.quarterMark?.finalMark ?? Grade(rawValue: "-")
        if let grades = subjectLastMarks.marks {
            cell.lastMarks = grades
                .compactMap { $0.mark }
                .suffix(5)
        }
        cell.isYearGrades = subjectLastMarks.quarterMark?.quarter == .final
        cell.updateUI()

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: lastMarksCollectionView.frame.size.width, height: 92)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let mark = lastMarks[indexPath.row]?.marks?.first else { return }
        let lastMakrsDetailsVC = LastMarksDetailsVC(performanceAPI: performanceAPI, quater: mark.quarter, subjectId: mark.subject)
        lastMakrsDetailsVC.titleText = lastMarks[indexPath.row]?.name
        lastMakrsDetailsVC.title = "Последние оценки"
        self.navigationController?.pushViewController(lastMakrsDetailsVC, animated: true)
    }

}

extension QuaterMarksPanelVC: QuaterBarDelegate {
    func quaterDidSelect(quater: Quater) {
        self.getQuaterLastMarks(quater: quater.rawValue)
        switch quater {
        case .first, .second, .third, .fourth:
            self.emptyView.subtitle = "Мы оповестим вас, когда оценки за \(quater.romanNumberSign) будут доступны в приложении"
        case .final:
            self.emptyView.subtitle = "Мы оповестим вас, когда оценки за год будут доступны в приложении"
        }
    }
}
