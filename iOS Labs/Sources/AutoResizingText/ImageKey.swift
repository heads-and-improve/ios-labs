//
//  ImageKey.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 09.09.2021.
//

import UIKit

enum ImageKey: String {
    
    case share = "share-image"
    case delete = "delete-image"
    
}

extension ImageKey: ImageKeyed { }
