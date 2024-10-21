import UIKit
import SwiftUI

enum FontType {
    case regular
    case medium
    case semiBold
    case bold
    case extraBold
    
    var weight: Font.Weight {
        switch self {
        case .regular:
            return .regular
        case .medium:
            return .medium
        case .semiBold:
            return .semibold
        case .bold:
            return .bold
        case .extraBold:
            return .heavy
        }
    }
}

extension Font {
    
    static func custom(_ type: FontType, size: CGFloat) -> Font {
        return .system(size: size, weight: type.weight)
    }
    
}

extension UIFont {
    
    static func custom(_ type: FontType, size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: type.uiFontWeight)
    }
}

private extension FontType {
    var uiFontWeight: UIFont.Weight {
        switch self {
        case .regular:
            return .regular
        case .medium:
            return .medium
        case .semiBold:
            return .semibold
        case .bold:
            return .bold
        case .extraBold:
            return .heavy
        }
    }
}
