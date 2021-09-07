//
//  CombineOperatorsViewController.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 08.09.2021.
//

import UIKit
import Combine

final class CombineOperatorsViewController: UIViewController {
    
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

extension CombineOperatorsViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }

        guard !isBusy else { return }
        isBusy = true
        spinner.startAnimating()
        
        var components = URLComponents()
        components.scheme = "https"
        guard let url = components.url else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.isBusy = false
            self?.spinner.stopAnimating()
        }
    }
}

struct RequestFactory {

    typealias Method = (_ endpoint: URL, _ value: String) -> URLRequest?

    private let endpointString: String
    private let method: Method

    init(_ endpointString: String, method: @escaping Method) {
        self.endpointString = endpointString
        self.method = method
    }

    func callAsFunction(_ value: String) -> URLRequest? {
        URL(string: endpointString)
            .flatMap { endpoint in self.method(endpoint, value) }
    }
}

struct NetworkingUseCase {

    private let factory: RequestFactory

    init(factory: RequestFactory) {
        self.factory = factory
    }

    func callAsFunction<S: Decodable>(_ value: String) -> AnyPublisher<S, Error> {
        factory(value)
            .flatMap { request in
                URLSession.shared.dataTaskPublisher(for: request)
                    .map { data, _ in data }
                    .decode(type: S.self, decoder: JSONDecoder())
                    .eraseToAnyPublisher()
            }
            ?? Fail(error: NetworkingError.some).eraseToAnyPublisher()
    }

    enum NetworkingError: Error {
        case some
    }
    
}
