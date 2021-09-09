//
//  TextStyle.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 09.09.2021.
//

import UIKit

struct TextStyleSet {

    /// Style used for one main title. Strongly adviced to be used no more than once per screen.
    let largeTitle: TextStyle
    /// Style used for smaller titles or subtitles. Supposed to be used several times per screen.
    let title: TextStyle
    /// Style used for most of descriptive texts in the app.
    let body: TextStyle

    fileprivate init(
        largeTitle: TextStyle,
        title: TextStyle,
        body: TextStyle
    ) {
        self.largeTitle = largeTitle
        self.title = title
        self.body = body
    }

    static var current: TextStyleSet {
        switch UIScreen.main.widthType {
        case .narrow:
            return TextStyleSet.small
        case .wide:
            return TextStyleSet.large
        }
    }
    
}

fileprivate extension TextStyleSet {

    static var large: TextStyleSet {
        TextStyleSet(
            largeTitle: TextStyle(size: 22.0, bold: true),
            title: TextStyle(size: 18.0, bold: true),
            body: TextStyle(size: 14.0, bold: false)
        )
    }

    static var small: TextStyleSet {
        TextStyleSet(
            largeTitle: TextStyle(size: 16.0, bold: true),
            title: TextStyle(size: 14.0, bold: true),
            body: TextStyle(size: 12.0, bold: false)
        )
    }
    
}

struct TextStyle {

    fileprivate let size: CGFloat
    fileprivate let bold: Bool
    fileprivate let color: UIColor?

    fileprivate init(size: CGFloat, bold: Bool, color: UIColor? = nil) {
        self.size = size
        self.bold = bold
        self.color = color
    }

    func colored(_ color: UIColor) -> TextStyle {
        TextStyle(size: self.size, bold: self.bold, color: self.color)
    }

}

extension NSAttributedString {

    convenience init(string: String, style: TextStyle) {

        var attributes: [NSAttributedString.Key: Any] = [
            .font: style.bold
                ? UIFont.boldSystemFont(ofSize: style.size)
                : UIFont.systemFont(ofSize: style.size)
        ]

        if let color = style.color {
            attributes[.foregroundColor] = color
        }

        self.init(string: string, attributes: attributes)
    }
    
}
