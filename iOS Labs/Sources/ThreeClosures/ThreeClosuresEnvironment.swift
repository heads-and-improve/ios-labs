//
//  ThreeClosuresEnvironment.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 08.10.2021.
//

import Foundation
import Combine

final class ThreeClosuresEnvironment {

    enum State {
        
        case dev
        case qa
        case prod
        
    }
    
    typealias FetchWeather = () -> AnyPublisher<Int, Error>

    let fetchWeather: FetchWeather
    let setupFetchWeather: (String) -> FetchWeather

    private init(fetchWeather: @escaping FetchWeather, setupFetchWeather: @escaping (String) -> FetchWeather) {
        self.fetchWeather = fetchWeather
        self.setupFetchWeather = setupFetchWeather
    }
    
    static func current(_ env: State) -> ThreeClosuresEnvironment {
        return ThreeClosuresEnvironment(
            fetchWeather: {
                Just(25)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            },
            setupFetchWeather: { city in
                {
                    Just(25)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
            }
        )
    }
    
}
