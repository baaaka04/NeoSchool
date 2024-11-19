import UIKit

class AutosizeUICollectionViewCell: UICollectionViewCell {
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()

        let collectionViewWidth = UIScreen.main.bounds.width
        let targetWidth = collectionViewWidth - 32 // Adjust this based on your padding/margin requirements
        let targetSize = CGSize(width: targetWidth, height: UIView.layoutFittingCompressedSize.height)
        let size = contentView.systemLayoutSizeFitting(targetSize,
                                                       withHorizontalFittingPriority: .required,
                                                       verticalFittingPriority: .fittingSizeLevel)
        var newFrame = layoutAttributes.frame
        newFrame.size.height = ceil(size.height)
        newFrame.size.width = ceil(size.width)
        layoutAttributes.frame = newFrame

        return layoutAttributes
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Update the shadow path when the cell's bounds change
        contentView.layer.shadowPath = UIBezierPath(
            roundedRect: contentView.bounds,
            cornerRadius: contentView.layer.cornerRadius
        ).cgPath
    }
}
