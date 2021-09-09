//
//  ColorPalette.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 10.09.2021.
//

import UIKit

struct ColorPalette {

    let text: UIColor
    let background: UIColor

    fileprivate init(
        text: UIColor,
        background: UIColor
    ) {
        self.text = text
        self.background = background
    }
    
    static var current: ColorPalette {
        switch UIScreen.main.traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            return light
        case .dark:
            return dark
        @unknown default:
            return light
        }
    }
}

extension ColorPalette {
    
    fileprivate static var light: ColorPalette {
        ColorPalette(
            text: .black,
            background: .white
        )
    }
    
    fileprivate static var dark: ColorPalette {
        ColorPalette(
            text: .systemGreen,
            background: .systemPink
        )
    }

}
