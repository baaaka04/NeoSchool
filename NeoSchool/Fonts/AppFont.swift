import Foundation
import UIKit

struct AppFont {
    enum FontType: String {
        /// weight: 100
        case thin = "Jost-Thin"
        /// weight: 100
        case thinItalic = "Jost-ThinItalic"
        /// weight: 200
        case extraLight = "Jost-ExtraLight"
        /// weight: 200
        case extraLightItalic = "Jost-ExtraLightItalic"
        /// weight: 300
        case light = "Jost-Light"
        /// weight: 300
        case lightItalic = "Jost-LightItalic"
        /// weight: 400
        case regular = "Jost-Regular"
        /// weight: 400
        case italic = "Jost-Italic"
        /// weight: 500
        case medium = "Jost-Medium"
        /// weight: 500
        case mediumItalic = "Jost-MediumItalic"
        /// weight: 600
        case semiBold = "Jost-SemiBold"
        /// weight: 600
        case semiBoldItalic = "Jost-SemiBoldItalic"
        /// weight: 700
        case bold = "Jost-Bold"
        /// weight: 700
        case boldItalic = "Jost-BoldItalic"
        /// weight: 800
        case extraBold = "Jost-ExtraBold"
        /// weight: 800
        case extraBoldItalic = "Jost-ExtraBoldItalic"
        /// weight: 900
        case black = "Jost-Black"
        /// weight: 900
        case blackItalic = "Jost-BlackItalic"
    }
    static func font(type: FontType, size: CGFloat) -> UIFont {
        UIFont(name: type.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
