//
//  GeneratePublishersViewController.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 30.08.2021.
//

import UIKit
//import Combine

final class GeneratePublishersViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    private enum State {
        case just
        case future
        case passthoughSubject
        case published
    }
    
    private var state: State = .just
    
//    private let passthroughSubject = PassthroughSubject<String, Error>()
//    private let input = Input()
//    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.layer.cornerRadius = 8.0
        
//        passthroughSubject
//            .subscribe(on: RunLoop.main)
//            .sink(
//                receiveCompletion: { completion in
//                    switch completion {
//                    case .finished:
//                        break
//                    case .failure(let error):
//                        print(error)
//                    }
//                },
//                receiveValue: { [weak self] value in
//                    self?.textLabel.text = value
//                }
//            ).store(in: &cancellables)
//
//        input.$text
//            .subscribe(on: RunLoop.main)
//            .sink(
//                receiveCompletion: { completion in
//                    switch completion {
//                    case .finished:
//                        break
//                    case .failure(let error):
//                        print(error)
//                    }
//                },
//                receiveValue: { [weak self] value in
//                    self?.textLabel.text = value
//                }
//            ).store(in: &cancellables)
    }
    
    @IBAction func handleSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            state = .just
        case 1:
            state = .future
        case 2:
            state = .passthoughSubject
        case 3:
            state = .published
        default:
            fatalError("Unknown Index")
        }
    }

    @IBAction func handleTapped(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let timeString = formatter.string(from: Date())
        let text = "Сообщение в " + timeString
        
        switch state {
        case .just:
//            Just(text)
//                .sink(
//                    receiveCompletion: { completion in
//                        switch completion {
//                        case .finished:
//                            break
//                        case .failure(let error):
//                            print(error.localizedDescription)
//                        }
//                    },
//                    receiveValue: { [weak self] value in
//                        self?.textLabel.text = value
//                    }
//                ).store(in: &cancellables)
            textLabel.text = text

        case .future:
//            Future<String, Error> { promise in
//                promise(.success(text))
//            }
//            .sink(
//                receiveCompletion: { completion in
//                    switch completion {
//                    case .finished:
//                        break
//                    case .failure(let error):
//                        print(error)
//                    }
//                },
//                receiveValue: { [weak self] value in
//                    self?.textLabel.text = value
//                }
//            ).store(in: &cancellables)
            textLabel.text = text

        case .passthoughSubject:
//            passthroughSubject.send(text)
            textLabel.text = text

        case .published:
//            input.text = text
            textLabel.text = text

        }
    }
}
