//
//  ContextMenuPreviewViewController.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 25.08.2021.
//

import UIKit

class ContextMenuPreviewViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }

}
