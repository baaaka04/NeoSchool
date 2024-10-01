import UIKit
import SnapKit

class FilesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let imagesAPI: ImagesAPI?
    
    private var attachedFiles : [AttachedFile] = []
    private var urls : [String]?
    var onPressRemove : ((_ file: AttachedFile) -> Void)?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.isScrollEnabled = false
        cv.backgroundColor = .clear
        cv.register(FilesCollectionViewCell.self, forCellWithReuseIdentifier: FilesCollectionViewCell.identifier)
        return cv
    }()
    
    //MARK: initialization to display images from backend
    init(urls: [String]? = nil) {
        self.urls = urls
        self.imagesAPI = ImagesAPI()

        super.init(nibName: nil, bundle: nil)
    }
    //MARK: initialization to display images from device
    init(attachedFiles: [AttachedFile]?) {
        self.attachedFiles = attachedFiles ?? []
        self.imagesAPI = nil
        self.urls = nil
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        getDataFromUrls()
    }

    private func getDataFromUrls() {
        guard let urls else { return }
        self.attachedFiles = []

        Task {
            await withTaskGroup(of: (String, UIImage?).self) { taskGroup in
                for url in urls {
                    taskGroup.addTask {
                        do {
                            let image = try await self.imagesAPI?.loadImage(url: url)
                            return (url, image)
                        } catch {
                            print("Error loading image from URL: \(url), \(error)")
                            return (url, nil)
                        }
                    }
                }

                for await (url, image) in taskGroup {
                    if let image = image {
                        let newFile = AttachedFile(image: image)
                        self.attachedFiles.append(newFile)
                    } else {
                        print("No image loaded for URL: \(url)")
                    }
                }

                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        attachedFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilesCollectionViewCell.identifier, for: indexPath) as? FilesCollectionViewCell else { return FilesCollectionViewCell(frame: .zero) }
        
        cell.attachedFile = attachedFiles[indexPath.item]
        cell.onPressRemove = onPressRemove
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let image = attachedFiles[indexPath.item].image else { return }
        let zoomImageView = ZoomPictureViewController(image: image)
        self.navigationController?.pushViewController(zoomImageView, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 64)
    }
    
    func update(attachedFiles: [AttachedFile]) {
        self.attachedFiles = attachedFiles
        collectionView.reloadData()
    }

    func update(urls: [String]?) {
        self.urls = urls
        getDataFromUrls()
    }

}
