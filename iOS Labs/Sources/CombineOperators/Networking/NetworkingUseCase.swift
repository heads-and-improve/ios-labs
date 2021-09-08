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
                    .eraseToAnyPublisher()
            }
            ?? Fail(error: NetworkingError.badUrl).eraseToAnyPublisher()
    }

    enum NetworkingError: Error {
        case badUrl
        case other
    }
    
}