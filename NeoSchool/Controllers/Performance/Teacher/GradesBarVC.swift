import SnapKit
import UIKit

protocol GradesBarDelegate: AnyObject {
    func itemDidSelected(itemId: Int, subjects: [SubjectName])
}

class GradesBarVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var grades: [GradeName]?
    private let performanceAPI: PerformanceAPIProtocol
    weak var delegate: GradesBarDelegate?
    private var textColor: UIColor

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.register(GradesBarCell.self, forCellWithReuseIdentifier: GradesBarCell.identifier)
        return collection
    }()

    init(performanceAPI: PerformanceAPIProtocol, textColor: UIColor = .white) {
        self.performanceAPI = performanceAPI
        self.textColor = textColor

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getGrades()
    }

    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func getGrades() {
        Task {
            do {
                self.grades = try await performanceAPI.getGrades()
            } catch {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        self.grades?.count ?? 0
    }

    func collectionView(_: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(
            withReuseIdentifier: GradesBarCell.identifier,
            for: indexPath) as? GradesBarCell,
              let grade = self.grades?[indexPath.item]
        else { return GradesBarCell(frame: .zero) }
        cell.gradeNameText = grade.name
        cell.textColor = self.textColor

        if indexPath.item == 0 && !cell.isSelected {
            self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            cell.isSelected = true
            delegate?.itemDidSelected(itemId: grade.id, subjects: grade.subjects ?? [])
        }

        return cell
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        CGSize(width: self.collectionView.frame.size.width / 6, height: self.collectionView.frame.size.height)
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let grade = grades?[indexPath.item], let subjects = grade.subjects else { return }
        delegate?.itemDidSelected(itemId: grade.id, subjects: subjects)
    }
}
