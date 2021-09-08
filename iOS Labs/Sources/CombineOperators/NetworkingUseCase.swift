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

    init(factory: RequestFactory) {
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

struct RequestFactory {

    typealias Make = (_ endpoint: URL, _ apiKey: String?, _ value: String) -> URLRequest?

    private let endpointStr: String
    private let apiKey: String?
    private let make: Make

    init(endpointStr: String, apiKey: String? = nil, make: @escaping Make) {
        self.endpointStr = endpointStr
        self.apiKey = apiKey
        self.make = make
    }

    func callAsFunction(_ value: String) -> URLRequest? {
        URL(string: endpointStr)
            .flatMap { endpoint in self.make(endpoint, self.apiKey, value) }
    }

    func get() -> RequestFactory {
        RequestFactory(
            endpointStr: self.endpointStr,
            apiKey: self.apiKey,
            make: { endpoint, apiKey, value in
                var request = self.make(endpoint, apiKey, value)
                request?.httpMethod = "GET"
                return request
            }
        )
    }

    func post() -> RequestFactory {
        RequestFactory(
            endpointStr: self.endpointStr,
            apiKey: self.apiKey,
            make: { endpoint, apiKey, value in
                var request = self.make(endpoint, apiKey, value)
                request?.httpMethod = "POST"
                return request
            }
        )
    }
}
