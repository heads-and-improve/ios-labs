//
//  ContextMenuDetailsViewController.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 25.08.2021.
//

import UIKit

class ContextMenuDetailsViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    var sightseeing: Sightseeing?

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = sightseeing?.name
        guard let imageName = sightseeing?.imageName else { return }
        imageView.image = UIImage(named: imageName)
    }

}
