//
//  PhotoAlbum.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 26.10.2021.
//

import UIKit

struct PhotoAlbum {

    let folderOne: [UIImage]
    let folderTwo: [UIImage]
    let folderThree: [UIImage]
    
    var isEmpty: Bool { folderOne.isEmpty && folderTwo.isEmpty && folderThree.isEmpty }
    
    init(
        _ folderOne: [UIImage],
        _ folderTwo: [UIImage],
        _ folderThree: [UIImage]
    ) {
        self.folderOne = folderOne
        self.folderTwo = folderTwo
        self.folderThree = folderThree
    }
    
    init() {
        self.folderOne = []
        self.folderTwo = []
        self.folderThree = []
    }

}
