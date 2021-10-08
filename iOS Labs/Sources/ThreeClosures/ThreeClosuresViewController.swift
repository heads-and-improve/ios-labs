//
//  ThreeClosuresViewController.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 08.10.2021.
//

import UIKit
import Combine

final class ThreeClosuresViewController: UIViewController {
    
    private enum CityName: String {

        case novosib = "Новосибирск"
        case saransk = "Саранск"
        case piter = "Санкт-Петербург"

    }

    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var refreshButton: ThreeClosuresRefreshButton!
    
    private var cancellable: AnyCancellable!

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshButton.addTarget(self, action: #selector(handleTapped), for: .touchDown)
//        refreshButton.onTap = { [weak self] city in
//            // TODO: Code fetching function
//            self?.tempLabel.text = city
//        }
        refreshButton.city = CityName.novosib.rawValue
    }

    @IBAction func handleSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            refreshButton.city = CityName.novosib.rawValue
        case 1:
            refreshButton.city = CityName.saransk.rawValue
        case 2:
            refreshButton.city = CityName.piter.rawValue
        default:
            refreshButton.city = nil
        }
    }
    
    @objc
    private func handleTapped() {
        cancellable = ThreeClosuresEnvironment.current(.dev).fetchTemp(refreshButton.city)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] temp in
                    self?.tempLabel.text = "\(temp) C"
                }
            )
    }
}
