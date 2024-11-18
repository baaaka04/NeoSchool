import UIKit

struct AttachedFile {
    let id: String = UUID().uuidString
    var name: String
    let image: UIImage?

    init(image: UIImage?) {
        self.name = "image_\(self.id.suffix(5).lowercased()).jpg"
        self.image = image
    }
}
