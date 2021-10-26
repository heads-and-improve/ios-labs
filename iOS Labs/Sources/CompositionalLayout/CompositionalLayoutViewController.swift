//
//  CompositionalLayoutViewController.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 26.10.2021.
//

import UIKit
import Combine

final class CompositionalLayoutViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var photoAlbum = PhotoAlbum()
    
    private let getPhotoAlbum = GetPhotoAlbumUseCase()
    
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = makeLayout()
        getPhotoAlbum()
            .sink { [weak self] in
                self?.photoAlbum = $0
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionNumber, env in
            let group = NSCollectionLayoutGroup(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            return NSCollectionLayoutSection(group: group)
        }
    }
}

extension CompositionalLayoutViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        case 1:
            return 5
        case 2:
            return 5
        default:
            return 0
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompositionalLayoutCell", for: indexPath) as? CompositionalLayoutCell else {
            fatalError("Can't deque cell with identifier CompositionalLayoutCell")
        }
        return cell
    }
    
    
}
