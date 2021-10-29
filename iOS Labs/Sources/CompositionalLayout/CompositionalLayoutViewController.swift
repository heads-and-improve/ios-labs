//
//  CompositionalLayoutViewController.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 26.10.2021.
//

import UIKit

final class CompositionalLayoutViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var photoAlbum = PhotoAlbum()
    
    private let getPhotoAlbum = CompositionalLayoutNetworkingClient()

    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.makeLayout()
    }
    
    @IBAction private func handleTap(_ sender: UIButton) {
        getPhotoAlbum(
            tagOne: "котик", "пицца", "осень",
            onStart: { [weak self] in
                self?.spinner.startAnimating()
            },
            onComplete: { [weak self] album in
                self?.spinner.stopAnimating()
                self?.photoAlbum = album
                self?.collectionView.reloadData()
            }
        )
    }
    
}

extension CompositionalLayoutViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        photoAlbum.isEmpty ? 0 : 3
        0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return photoAlbum.folderOne.count
        case 1:
            return photoAlbum.folderTwo.count
        case 2:
            return photoAlbum.folderThree.count
        default:
            return 0
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompositionalLayoutCell", for: indexPath) as? CompositionalLayoutCell
        else { fatalError("Can't deque cell with identifier CompositionalLayoutCell") }

        let index = indexPath.item
        let image: UIImage?
        switch indexPath.section {
        case 0:
            image = photoAlbum.folderOne[index]
        case 1:
            image = photoAlbum.folderTwo[index]
        case 2:
            image = photoAlbum.folderThree[index]
        default:
            image = nil
        }
        cell.imageView.image = image

        return cell
    }
}

fileprivate extension UICollectionViewCompositionalLayout {
    
    static func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionNumber, env in

            switch sectionNumber {
            case 0:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets.leading = 12.0
                item.contentInsets.trailing = 12.0
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(200.0)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                group.contentInsets.top = 12.0
                group.contentInsets.bottom = 12.0
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .paging
                
                return section
                
//            case 1:
//                let itemSize = NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(0.20),
//                    heightDimension: .absolute(150.0)
//                )
//                let item = NSCollectionLayoutItem(layoutSize: itemSize)
//                item.contentInsets.leading = 12.0
//                item.contentInsets.trailing = 12.0
//                item.contentInsets.top = 12.0
//                item.contentInsets.bottom = 12.0
//
//                let groupSize = NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1.0),
//                    heightDimension: .estimated(50.0)
//                )
//                let group = NSCollectionLayoutGroup.horizontal(
//                    layoutSize: groupSize,
//                    subitems: [item]
//                )
//
//                let section = NSCollectionLayoutSection(group: group)
//
//                return section
//
//            case 2:
//                let itemSize = NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1.0),
//                    heightDimension: .absolute(200.0)
//                )
//                let item = NSCollectionLayoutItem(layoutSize: itemSize)
//                item.contentInsets.leading = 12.0
//                item.contentInsets.trailing = 12.0
//                item.contentInsets.top = 12.0
//                item.contentInsets.bottom = 12.0
//
//                let groupSize = NSCollectionLayoutSize(
//                    widthDimension: .absolute(env.container.contentSize.width * 0.75),
//                    heightDimension: .estimated(200.0)
//                )
//                let group = NSCollectionLayoutGroup.horizontal(
//                    layoutSize: groupSize,
//                    subitems: [item]
//                )
//
//                let section = NSCollectionLayoutSection(group: group)
//                section.orthogonalScrollingBehavior = .continuous
//
//                return section
                
            default:
                return nil
            }
        }
    }
}
