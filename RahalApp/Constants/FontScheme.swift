import Foundation
import SwiftUI

class FontScheme: NSObject {
    static func kSFArabicBold(size: CGFloat) -> Font {
        return Font.custom(FontConstant.kSFArabicBold, size: size)
    }

    static func kSFArabicSemibold(size: CGFloat) -> Font {
        return Font.custom(FontConstant.kSFArabicSemibold, size: size)
    }

    static func kSFArabicRegular(size: CGFloat) -> Font {
        return Font.custom(FontConstant.kSFArabicRegular, size: size)
    }

    static func kSFArabicLight(size: CGFloat) -> Font {
        return Font.custom(FontConstant.kSFArabicLight, size: size)
    }

    static func fontFromConstant(fontName: String, size: CGFloat) -> Font {
        var result = Font.system(size: size)

        switch fontName {
        case "kSFArabicBold":
            result = self.kSFArabicBold(size: size)
        case "kSFArabicSemibold":
            result = self.kSFArabicSemibold(size: size)
        case "kSFArabicRegular":
            result = self.kSFArabicRegular(size: size)
        case "kSFArabicLight":
            result = self.kSFArabicLight(size: size)
        default:
            result = self.kSFArabicBold(size: size)
        }
        return result
    }

    enum FontConstant {
        /**
         * Please Add this fonts Manually
         */
        static let kSFArabicBold: String = "SFArabic-Bold"
        /**
         * Please Add this fonts Manually
         */
        static let kSFArabicSemibold: String = "SFArabic-Semibold"
        /**
         * Please Add this fonts Manually
         */
        static let kSFArabicRegular: String = "SFArabic-Regular"
        /**
         * Please Add this fonts Manually
         */
        static let kSFArabicLight: String = "SFArabic-Light"
    }
}
