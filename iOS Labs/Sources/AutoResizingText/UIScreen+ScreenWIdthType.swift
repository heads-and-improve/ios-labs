//
//  UIScreen+ScreenWIdthType.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 09.09.2021.
//

import UIKit

extension UIScreen {

    enum WidthType {
        /// The width of models: 2G, 3G, 3GS, 4, 4s, 5, 5c, 5s, SE.
        case narrow
        /// The width of models: 6, 6s, 6, 6s+, 7, 7+, 8, 8+, X, Xs, Xs Max, Xr, 11, 11 Pro, 11 Pro Max.
        case wide
    }
    
    /// This property describes with of the main screen in the portrait orientation. The width is divided into several types.
    var widthType: WidthType {
        switch Self.main.bounds.width {
        case 0...320:
            return .narrow
        default:
            return .wide
        }
    }
    
}
