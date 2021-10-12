//
//  ThreeClosuresViewController.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 08.10.2021.
//

import UIKit
import Combine

final class ThreeClosuresViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var updateButton: ThreeClosuresUpdateButton!
    
    private let viewModel = ThreeClosuresViewModel()
//    private let viewModel = ThreeClosuresViewModelOpt()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeOnUpdateButton()
        subscrubeToViewModel()
        passCityToViewModel(segmentedControl)
    }

    private func subscribeOnUpdateButton() {
        updateButton.onTap = { [weak self] city in
            guard let city = city else { fatalError("City was not set") }
            self?.viewModel.setCity(cityName: city)
        }
    }

    private func subscrubeToViewModel() {
        viewModel.onCityUpdated = { [weak self] coords in
            self?.updateButton.city = coords
        }
        viewModel.onTempUpdated = { [weak self] tempString in
            self?.tempLabel.text = tempString
        }
    }

    @IBAction func handleSelected(_ sender: UISegmentedControl) {
        passCityToViewModel(sender)
    }

    private func passCityToViewModel(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        guard let city = sender.titleForSegment(at: index) else { fatalError("No city name for index") }
        viewModel.setCity(cityName: city)
    }

    @IBAction func handleTapped(_ sender: ThreeClosuresUpdateButton) {
        guard let city = sender.city else { fatalError("City was not set") }
        viewModel.updateTemp(cityName: city)
//        viewModel.updateTemp()
    }
}
