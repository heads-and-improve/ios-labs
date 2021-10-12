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

    override func viewDidLoad() {
        super.viewDidLoad()
        subscrubeToViewModel()
        passCityToViewModel(segmentedControl)
    }

    private func subscrubeToViewModel() {
        viewModel.onUpdateCity = { [weak self] coords in
            self?.updateButton.city = coords
        }
        viewModel.onUpdateTemp = { [weak self] temp in
            self?.tempLabel.text = "\(temp) °C"
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
        viewModel.updateTemp(coords: city)
    }
    
}
