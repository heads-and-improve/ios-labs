//
//  RequestProvider.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 22.09.2021.
//

import Foundation
import Combine
import UIKit

enum NetworkingError: Error {

    case url(URLError)
    case response(Int, Data)
    case decoding(Data)
    case unknown

}

struct RequestProvider {
    
    private static let token: () -> String? = {
        UserDefaults.standard.string(forKey: "kToken")
    }
    
    init() { }
    
    private func task(_ target: RequestComposable) -> AnyPublisher<Data, Error> {
        var components = URLComponents()
        components.scheme = target.scheme
        components.host = target.host
        components.path = target.path
        if !target.query.isEmpty {
            components.queryItems = target.query.map { key, value in
                URLQueryItem(name: key, value: value)
            }
        }
        let request = components.url
            .flatMap { url -> URLRequest? in
                var request = URLRequest(url: url)
                if let token = Self.token() {
                    request.addValue("Authorization", forHTTPHeaderField: token)
                }
                return request
            }

        guard let request = request else {
            return Fail(error: NetworkingError.url(URLError(.badURL)))
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { urlError -> NetworkingError in
                .url(urlError)
            }
            .tryMap { data, response -> Data in
                guard let urlResponse = response as? HTTPURLResponse else {
                    throw NetworkingError.unknown
                }
                guard (200...299).contains(urlResponse.statusCode) else {
                    throw NetworkingError.response(urlResponse.statusCode, data)
                }
                return data
            }
            .eraseToAnyPublisher()
    }
    
    func task<T: Decodable>(_ target: RequestComposable) -> AnyPublisher<T, Error> {
        task(target)
            .map { (data: Data) -> Data in data }
            .tryMap { data in
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    throw NetworkingError.decoding(data)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func task(_ target: RequestComposable) -> AnyPublisher<UIImage, Error> {
        task(target)
            .map { data in UIImage(data: data) }
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
}
