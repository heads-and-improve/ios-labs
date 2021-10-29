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
    private var urlsStrings: [String] = []
    
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
//        urlsStrings.count
        images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FlickrPhotoCell", for: indexPath) as? FlickrPhotoCell else {
            fatalError("Could not instantiate cell")
        }
        cell.photoView.image = images[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "FlickrPhotoCell", for: indexPath)
//        cell.textLabel?.text = urlsStrings[indexPath.row]
        return cell
    }
}

extension CombineOperatorsViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        guard
            let text = searchBar.text,
            !text.isEmpty,
            !isBusy
        else { return }
        setUIToLoading()

        let apiKey = Bundle.main.url(forResource: "apikeys", withExtension: "plist")
            .flatMap { try? Data(contentsOf: $0) }
            .flatMap { try? PropertyListSerialization.propertyList(from: $0, options: [], format: nil) }
            .flatMap { $0 as? Dictionary<String, String> }
            .flatMap { $0["flickr"] }

        var components = URLComponents()
        components.scheme = "https"
        components.host = "flickr.com"
        components.path = "/services/rest/"
        components.queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "tags", value: text),
            URLQueryItem(name: "per_page", value: "25"),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
        ]
        guard let url = components.url else { return }
        let request = URLRequest(url: url)
        URLSession.shared.dataTaskPublisher(for: request)
            .map { data, _ in data }
            .decode(type: FlickrResponse.self, decoder: JSONDecoder())
            .map { $0.photos.photo }
            .flatMap { photos in
                photos.publisher
                    .flatMap { photo -> AnyPublisher<UIImage?, Never> in
                        var components = URLComponents()
                        components.scheme = "https"
                        components.host = "live.staticflickr.com"
                        components.path = "/\(photo.server)/\(photo.id)_\(photo.secret)" + "_c.jpg"
                        guard let url = components.url else { return Just<UIImage?>(nil).eraseToAnyPublisher() }
                        let request = URLRequest(url: url)
                        return URLSession.shared.dataTaskPublisher(for: request)
                            .map { data, response in data }
                            .map { UIImage(data: $0) }
                            .replaceError(with: nil)
                            .eraseToAnyPublisher()
                    }
                    .compactMap { $0 }
                    .collect()
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        break
                    }
                    self?.updateUI()
                },
                receiveValue: { [weak self] images in
                    self?.images = images
                    self?.updateUI()
                }
            ).store(in: &cancellables)
    }
    
    private func setUIToLoading() {
        isBusy = true
        spinner.startAnimating()
    }
    
    private func updateUI() {
        isBusy = false
        tableView.reloadData()
        spinner.stopAnimating()
    }
}

