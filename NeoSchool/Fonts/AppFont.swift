import Foundation
import UIKit

struct AppFont {
    enum FontType: String {
        ///weight: 100
        case Thin = "Jost-Thin"
        ///weight: 100
        case ThinItalic = "Jost-ThinItalic"
        ///weight: 200
        case ExtraLight = "Jost-ExtraLight"
        ///weight: 200
        case ExtraLightItalic = "Jost-ExtraLightItalic"
        ///weight: 300
        case Light = "Jost-Light"
        ///weight: 300
        case LightItalic = "Jost-LightItalic"
        ///weight: 400
        case Regular = "Jost-Regular"
        ///weight: 400
        case RegularItalic = "Jost-RegularItalic"
        ///weight: 500
        case Medium = "Jost-Medium"
        ///weight: 500
        case MediumItalic = "Jost-MediumItalic"
        ///weight: 600
        case SemiBold = "Jost-SemiBold"
        ///weight: 600
        case SemiBoldItalic = "Jost-SemiBoldItalic"
        ///weight: 700
        case Bold = "Jost-Bold"
        ///weight: 700
        case BoldItalic = "Jost-BoldItalic"
        ///weight: 800
        case ExtraBold = "Jost-ExtraBold"
        ///weight: 800
        case ExtraBoldItalic = "Jost-ExtraBoldItalic"
        ///weight: 900
        case Black = "Jost-Black"
        ///weight: 900
        case BlackItalic = "Jost-BlackItalic"
        
    }
    static func font(type: FontType, size: CGFloat) -> UIFont{
        return UIFont(name: type.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
