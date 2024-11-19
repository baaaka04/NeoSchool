import SnapKit
import UIKit

class ItemsListViewController: DetailTitledViewController {
    // MARK: Pagination
    var currentPage = 1
    var totalPages = 1
    var isLoading = false

    var subtitleText: String? {
        didSet { subtitleLabel.text = subtitleText }
    }
    var itemsList: [TeacherClassItem] = []

    private let subtitleLabel = GrayUILabel(font: AppFont.font(type: .medium, size: 16))

    let emptyListView = NotepadView()
    let teacherListCollectionView = TeacherListCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(subtitleLabel)
        view.addSubview(emptyListView)
        view.addSubview(teacherListCollectionView)

        setupUI()
    }

    private func setupUI() {
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        emptyListView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        teacherListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(6)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    func updateUI() {
        teacherListCollectionView.reloadData()
        emptyListView.isHidden = !self.itemsList.isEmpty
        teacherListCollectionView.isHidden = self.itemsList.isEmpty
    }
}
