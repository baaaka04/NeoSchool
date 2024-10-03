import UIKit
import SnapKit

protocol GradesBarVMProtocol {
    func getGrades() async throws -> [String]
}

class GradesBarVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var grades: [String]?
    private let vm: GradesBarVMProtocol

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

    init(vm: GradesBarVMProtocol) {
        self.vm = vm

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
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
                self.grades = try await vm.getGrades()
            } catch {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        grades?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: GradesBarCell.identifier, for: indexPath) as? GradesBarCell, let grades
        else { return GradesBarCell(frame: .zero) }
        cell.gradeNameText = grades[indexPath.item]

        if indexPath.item == 0 && !cell.isSelected {
            self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            cell.isSelected = true
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width/6, height: self.collectionView.frame.size.height)
    }


}
