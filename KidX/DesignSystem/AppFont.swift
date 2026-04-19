//
//  AppFont.swift
//  BaseApp
//
//  Created by Tran Van Quang on 9/2/26.
//

import Foundation
import UIKit

internal struct FontConvertible {
    internal let name: String
    internal let family: String
    internal let path: String
    
#if os(macOS)
    internal typealias Font = NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
    internal typealias Font = UIFont
#endif
    
    internal func font(size: CGFloat) -> Font {
        guard let font = Font(font: self, size: size) else {
            fatalError("Unable to initialize font '\(name)' (\(family))")
        }
        return font
    }
    
    internal func register() {
        // swiftlint:disable:next conditional_returns_on_newline
        guard let url = url else { return }
        CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
    
    fileprivate var url: URL? {
        // swiftlint:disable:next implicit_return
        return Bundle.main.url(forResource: path, withExtension: nil)
    }
}

internal extension FontConvertible.Font {
    convenience init?(font: FontConvertible, size: CGFloat) {
#if os(iOS) || os(tvOS) || os(watchOS)
        if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
            font.register()
        }
#elseif os(macOS)
        if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
            font.register()
        }
#endif
        
        self.init(name: font.name, size: size)
    }
}

struct LexendFonts {
    static let regular = FontConvertible(name: "Lexend-Regular", family: "Lexend", path: "Lexend-Regular.ttf")
    static let medium = FontConvertible(name: "Lexend-Medium", family: "Lexend", path: "Lexend-Medium.ttf")
    static let semiBold = FontConvertible(name: "Lexend-SemiBold", family: "Lexend", path: "Lexend-SemiBold.ttf")
}

enum FontWeight: String {
    case semiBold, medium, regular

    var fontName: String {
        switch self {
        case .semiBold:     return LexendFonts.semiBold.name
        case .medium:       return LexendFonts.medium.name
        case .regular:      return LexendFonts.regular.name
        }
    }
}

extension UIFont {
    static func custom(_ size: CGFloat, _ weight: FontWeight) -> UIFont {
        let scale: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 1.5 : 1.0
        let pointSize = CGFloat(size) * scale
        return UIFont(name: weight.fontName, size: pointSize) ?? UIFont.systemFont(ofSize: pointSize)
    }
}
