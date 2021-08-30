//
//  GeneratePublishersViewController.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 30.08.2021.
//

import UIKit
import Combine

final class GeneratePublishersViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var resultsController = UIViewController()
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.automaticallyShowsCancelButton = false
        controller.hidesNavigationBarDuringPresentation = false
        controller.obscuresBackgroundDuringPresentation = true
        controller.searchBar.delegate = self
        return controller
    }()
    
    private enum State {
        case future
        case passthoughSubject
        case published
        case fromTheBox
    }
    
    private var state: State = .future
    
    private var urlStrings = Array<String>.init(repeating: "URL Фотографии", count: 100)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
    }
    
    @IBAction func handleSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: state = .future
        case 1: state = .passthoughSubject
        case 2: state = .published
        case 3: state = .fromTheBox
        default:
            fatalError("Unknown Index")
        }
    }
}

extension GeneratePublishersViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        print("SEARCH TEXT")
    }
}

extension GeneratePublishersViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        urlStrings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GeneratePublishersCell", for: indexPath)
        cell.textLabel?.text = urlStrings[indexPath.row]
        return cell
    }
}
