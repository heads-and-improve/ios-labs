//
//  NetworkingUseCase.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 08.09.2021.
//

import UIKit
import Combine

enum NetworkableError: Error {
    
    case url(URLError)
    case some(String)

}

protocol Networkable {

    func load<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error>
    
    func load(_ request: URLRequest) -> AnyPublisher<UIImage, Error>

}

extension Networkable {

    func load<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: request)
            .mapError { NetworkableError.url($0) }
            .map { data, _ in data }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func load(_ request: URLRequest) -> AnyPublisher<UIImage, Error> {
        URLSession.shared.dataTaskPublisher(for: request)
            .mapError { NetworkableError.url($0) }
            .map { data, _ in data }
            .map { UIImage(data: $0) }
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
}
