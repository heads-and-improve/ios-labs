//
//  CombineErrorsViewController.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 14.09.2021.
//

import UIKit
import Combine

final class CombineErrorsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!

    private lazy var searchController: UISearchController = {
       let controller = UISearchController()
        controller.searchBar.delegate = self
        return controller
    }()

    private let viewModel = CombineErrorsViewModel()

    private var images: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        subscribeToViewModel()
        
        let just = Just(1000)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    private func subscribeToViewModel() {
        viewModel.onStart = { [weak self] busy in
            self?.setUI(toBusy: busy)
        }
        viewModel.onSuccess = { [weak self] images in
            self?.images = images
            self?.tableView.reloadData()
        }
        viewModel.onError = { [weak self] message in
            self?.showAlert(message)
        }
    }

    private func showAlert(_ message: String) {
        let controller = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ок", style: .default)
        controller.addAction(ok)
        present(controller, animated: true, completion: nil)
    }
    
    private func setUI(toBusy busy: Bool) {
        busy ? spinner.startAnimating() : spinner.stopAnimating()
//        if busy {
//            spinner.startAnimating()
//        } else {
//            spinner.stopAnimating()
//        }
    }

}

extension CombineErrorsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        images.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FlickrPhotoCell", for: indexPath) as? FlickrPhotoCell else {
            fatalError("Could not instantiate cell")
        }
        cell.photoView.image = images[indexPath.row]
        return cell
    }
}

extension CombineErrorsViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        viewModel.load(text)
    }
}

