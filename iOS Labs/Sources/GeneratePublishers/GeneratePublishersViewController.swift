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
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!

    private enum State: Int {
        case just = 0
        case future = 1
        case passthoughSubject = 2
        case published = 3
    }

    private var state: State = .just

    private let passthroughSubject = PassthroughSubject<String, Error>()
    private let input = Input()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        button.layer.cornerRadius = 8.0

        passthroughSubject
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error)
                    }
                },
                receiveValue: { [weak self] value in
                    self?.label.text = value
                }
            ).store(in: &cancellables)

        input.$text
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error)
                    }
                },
                receiveValue: { [weak self] value in
                    self?.label.text = value
                }
            ).store(in: &cancellables)
    }

    @IBAction func handleSelected(_ sender: UISegmentedControl) {
        state = .init(rawValue: segmentedControl.selectedSegmentIndex) ?? .just
    }

    @IBAction func handleTapped(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let timeString = formatter.string(from: Date())
        let text = "Сообщение в " + timeString

        switch state {
        case .just:
            Just(text)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    },
                    receiveValue: { [weak self] value in
                        self?.label.text = value
                    }
                ).store(in: &cancellables)

        case .future:
            Future<String, Error> { promise in
                promise(.success(text))
            }
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error)
                    }
                },
                receiveValue: { [weak self] value in
                    self?.label.text = value
                }
            ).store(in: &cancellables)

        case .passthoughSubject:
            passthroughSubject.send(text)
//            label.text = text

        case .published:
            input.text = text

        }
    }
}
