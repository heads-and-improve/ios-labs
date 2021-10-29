//
//  Publisher+do.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 27.10.2021.
//

import Foundation
import Combine

extension Publisher {

    func `do`(_ sideEffect: @escaping (Output) -> Void) -> AnyPublisher<Output, Failure> {
        map { output in
            sideEffect(output)
            return output
        }
        .eraseToAnyPublisher()
    }
}

