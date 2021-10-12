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
    private let updateTempEvent = PassthroughSubject<String, Error>()
    private var cancellables = Set<AnyCancellable>()
    
    var onCityUpdated: ((String) -> Void)?
    var onTempUpdated: ((String) -> Void)?
    
    init() {
        setCityEvent
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] cityName in
                    self?.onCityUpdated?(cityName)
                }
            )
            .store(in: &cancellables)
        
        
        let getTemp = ThreeClosuresNetworkingEnvironment.current(.qa).getTemp
        
        updateTempEvent
            .map { cityName in
                switch cityName {
                case "Новосиб": return CityCoords(55.00, 83.00)
                case "Саранск": return CityCoords(54.00, 45.00)
                case "Питер": return CityCoords(60.00, 30.00)
                default: fatalError("Unknown city")
                }
            }
            .flatMap { getTemp(coords: $0) }
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
    
    func updateTemp(cityName: String) {
        updateTempEvent.send(cityName)
    }
    
}
