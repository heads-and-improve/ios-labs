//
//  ThreeClosuresViewModelConventional.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 12.10.2021.
//

import Combine
import UIKit

final class ThreeClosuresViewModel {
    
    private let setCityEvent = PassthroughSubject<String, Error>()
    private let updateTempEvent = PassthroughSubject<CityCoordinates, Error>()
    private var cancellables = Set<AnyCancellable>()
    
    var onUpdateCity: ((CityCoordinates) -> Void)?
    var onUpdateTemp: ((Int) -> Void)?
    
    init() {
        setCityEvent
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] cityName in
                    let coords: CityCoordinates
                    switch cityName {
                    case "Новосиб": coords = .init(55.00, 83.00)
                    case "Саранск": coords = .init(54.00, 45.00)
                    case "Питер": coords = .init(60.00, 30.00)
                    default: fatalError("Unknown city")
                    }
                    self?.onUpdateCity?(coords)
                }
            )
            .store(in: &cancellables)
        
        
        let getTemp = ThreeClosuresNetworkingEnvironment.current(.dev).getTemp
        
        updateTempEvent
            .flatMap { getTemp(coords: $0) }
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] temp in
                    guard let temp = temp else { return }
                    self?.onUpdateTemp?(temp)
                }
            )
            .store(in: &cancellables)
    }
    
    func setCity(cityName: String) {
        setCityEvent.send(cityName)
    }
    
    func updateTemp(coords: CityCoordinates) {
        updateTempEvent.send(coords)
    }
    
}
