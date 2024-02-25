import UIKit

extension String {
    func getHeight(font: UIFont, width: CGFloat) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [ .font: font ]
        let attributedText = NSAttributedString(string: self, attributes: attributes)
        let constraintBox = CGSize(width: width, height: .greatestFiniteMagnitude)
        let textHeight = attributedText.boundingRect(
            with: constraintBox,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        ).height.rounded(.up)
        
        return textHeight
    }
}
