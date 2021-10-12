//
//  ThreeClosuerViewModelOpt.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 12.10.2021.
//

import UIKit
import Combine

final class ThreeClosuresViewModelOpt {

    private let setCityEvent = PassthroughSubject<String, Error>()
    private let updateTempEvent = PassthroughSubject<() -> AnyPublisher<Int?, Never>, Error>()
    private var cancellables = Set<AnyCancellable>()
    
    private var getTemp: () -> AnyPublisher<Int?, Never> = {
        Just(nil)
            .eraseToAnyPublisher()
    }

    var onCityUpdated: ((String) -> Void)?
    var onTempUpdated: ((String) -> Void)?

    init() {
        setCityEvent
            .do { [weak self] cityName in
                let coords: CityCoordinates
                switch cityName {
                case "Новосиб": coords = .init(55.00, 83.00)
                case "Саранск": coords = .init(54.00, 45.00)
                case "Питер": coords = .init(60.00, 30.00)
                default: fatalError("Unknown city")
                }

                self?.getTemp = ThreeClosuresLazyFetcher.getTemp(coords)
            }
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] cityName in
                    self?.onCityUpdated?(cityName)
                }
            )
            .store(in: &cancellables)
        
        updateTempEvent
            .flatMap { getTemp in getTemp() }
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] temp in
                    guard let temp = temp else { return }
                    var tempString = "\(abs(temp)) °C"
                    if temp > 0 {
                        tempString = "+" + tempString
                    } else if temp < 0 {
                        tempString = "-" + tempString
                    }
                    self?.onTempUpdated?(tempString)
                }
            )
            .store(in: &cancellables)
    }
    
    func setCity(cityName: String) {
        setCityEvent.send(cityName)
    }
    
    func updateTemp() {
        updateTempEvent.send(getTemp)
    }
}

fileprivate extension Publisher {

    func `do`(_ sideEffect: @escaping (Output) -> Void) -> AnyPublisher<Output, Failure> {
        map { output in
            sideEffect(output)
            return output
        }
        .eraseToAnyPublisher()
    }
}
