//
//  PhotoAlbum.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 26.10.2021.
//

import UIKit

struct PhotoAlbum {

    let firenzes: [UIImage]
    let ferraries: [UIImage]
    let pizzas: [UIImage]
    
    init(_ firenzes: [UIImage], _ ferraries: [UIImage], _ pizzas: [UIImage]) {
        self.firenzes = firenzes
        self.ferraries = ferraries
        self.pizzas = pizzas
    }
    
    init() {
        self.firenzes = []
        self.ferraries = []
        self.pizzas = []
    }

}
