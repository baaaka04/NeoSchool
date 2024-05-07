import UIKit


class ImagesAPI {
    
    func loadImage(url: String) async throws -> UIImage {
        guard let url = URL(string: url) else { throw URLError(.badURL) }
        let (data, resp) = try await URLSession.shared.data(from: url)
        guard let httpStatus = resp as? HTTPURLResponse, httpStatus.statusCode == 200 else { throw MyError.badNetwork }
        guard let image = UIImage(data: data) else { throw MyError.failDecoding }
        return image
    }
}
