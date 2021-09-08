//
//  CombineOperatorsViewController.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 08.09.2021.
//

import UIKit
import Combine

final class CombineOperatorsViewController: UIViewController {
    
    private var images: [UIImage] = []
    
    private var isBusy = false

    private var cancellables = Set<AnyCancellable>()

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    private lazy var searchController: UISearchController = {
       let controller = UISearchController()
        controller.searchBar.delegate = self
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
    }

}

extension CombineOperatorsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlickrPhotoCell", for: indexPath)
        cell.imageView?.image = images[indexPath.row]
        return cell
    }
}

extension CombineOperatorsViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        guard let text = searchBar.text else { return }

        guard !isBusy else { return }
        isBusy = true
        spinner.startAnimating()
        let apiKey = Bundle.main.url(forResource: "secrets", withExtension: "plist")
            .flatMap { try? Data(contentsOf: $0) }
            .flatMap { try? PropertyListSerialization.propertyList(from: $0, options: [], format: nil) }
            .flatMap { $0 as? Dictionary<String, String> }
            .flatMap { $0["apiKey"] }

        var components = URLComponents()
        components.scheme = "https"
        guard let url = components.url else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.isBusy = false
            self?.spinner.stopAnimating()
        }
    }
}
