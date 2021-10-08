//
//  ThreeClosuresEnvironment.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 08.10.2021.
//

import Foundation
import Combine

final class ThreeClosuresEnvironment {

    enum State { case dev, qa, prod }

    typealias TempPublisher = AnyPublisher<Int, Error>

    let fetchTemp: (String?) -> TempPublisher
    let setupFetchTemp: (String?) -> (() -> TempPublisher)

    private init(
        fetchTemp: @escaping (String?) -> TempPublisher,
        setupFetchTemp: @escaping (String?) -> (() -> TempPublisher)
    ) {
        self.fetchTemp = fetchTemp
        self.setupFetchTemp = setupFetchTemp
    }
    
    static func current(_ env: State) -> ThreeClosuresEnvironment {
        return ThreeClosuresEnvironment(
            fetchTemp: { city in
                Just(25)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            },
            setupFetchTemp: { city in
                {
                    Just(25)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
            }
        )
    }
    
}
