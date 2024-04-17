import UIKit
import SnapKit


class AttachedFilesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    weak var viewModel: SubjectDetailsViewModelRepresentable?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .clear
        cv.register(AttachedFilesCollectionViewCell.self, forCellWithReuseIdentifier: AttachedFilesCollectionViewCell.identifier)
        return cv
    }()
            
    init(viewModel: SubjectDetailsViewModelRepresentable?) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.attachedFiles.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttachedFilesCollectionViewCell.identifier, for: indexPath) as? AttachedFilesCollectionViewCell else {
            return AttachedFilesCollectionViewCell(frame: .zero)
        }
        cell.attachedFile = viewModel?.attachedFiles[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 64)
    }
    
    func reloadColletionView() {
        collectionView.reloadData()
    }

}

extension AttachedFilesViewController: AttachedFilesViewDelegate {
    
    func didTapRemoveFile(file: AttachedFile) {
        viewModel?.remove(file: file)
        
        collectionView.reloadData()
    }
    
    
}
