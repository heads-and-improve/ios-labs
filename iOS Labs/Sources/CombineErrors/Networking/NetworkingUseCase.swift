//
//  NetworkingUseCase.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 08.09.2021.
//

import Foundation
import Combine

struct NetworkingUseCase {

    private let factory: RequestFactory

    init(_ factory: RequestFactory) {
        self.factory = factory
    }

    func callAsFunction<T: Decodable>(_ value: String) -> AnyPublisher<T, Error> {
        factory(value)
            .flatMap { request in
                URLSession.shared.dataTaskPublisher(for: request)
                    .map { data, _ in data }
                    .decode(type: T.self, decoder: JSONDecoder())
                    .do { UserDefaults.standard.setValue($0, forKey: "kToken") }
                    .eraseToAnyPublisher()
            }
            ?? Fail(error: NetworkingError.badUrl).eraseToAnyPublisher()
    }

    enum NetworkingError: Error {
        case badUrl
        case other
    }
    
}

fileprivate extension Publisher {
    
    func `do`(_ sideEffect: @escaping (Output) -> Void) -> AnyPublisher<Output, Failure> {
        map { value in
            sideEffect(value)
            return value
        }
        .eraseToAnyPublisher()
    }
}
