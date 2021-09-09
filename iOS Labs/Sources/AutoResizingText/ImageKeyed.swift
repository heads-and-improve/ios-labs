//
//  ImageKey.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 09.09.2021.
//

import UIKit

protocol ImageKeyed where Self: RawRepresentable {

    var image: UIImage? { get }

}

extension ImageKeyed where RawValue == String {

    var image: UIImage? { UIImage(named: rawValue) }

}
