//
//  GetTemperatureUseCase.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 12.10.2021.
//

import Combine
import Foundation

//struct GetTempUseCase {
//
//    func callAsFunction(coords: CityCoordinates) -> AnyPublisher<Int?, Never> {
//
//        let apiKey = Bundle.main.url(forResource: "apikeys", withExtension: "plist")
//            .flatMap { try? Data(contentsOf: $0) }
//            .flatMap { try? PropertyListSerialization.propertyList(from: $0, options: [], format: nil) }
//            .flatMap { $0 as? Dictionary<String, String> }
//            .flatMap { $0["openweather"] }
//        guard let apiKey = apiKey else {
//            return Just(nil)
//                .eraseToAnyPublisher()
//        }
//
//        var components = URLComponents()
//        components.scheme = "https"
//        components.host = "api.openweathermap.org"
//        components.path = "/data/2.5/weather"
//        components.queryItems = [
//            URLQueryItem(name: "lat", value: "\(coords.lat)"),
//            URLQueryItem(name: "lon", value: "\(coords.lon)"),
//            URLQueryItem(name: "appid", value: "\(apiKey)")
//        ]
//        guard let url = components.url else {
//            return Just(nil)
//                .eraseToAnyPublisher()
//        }
//
//        let request = URLRequest(url: url)
//        return URLSession.shared.dataTaskPublisher(for: request)
//            .map { data, response in
//                data
//            }
//            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
//            .map { $0.main.temp - 273.0 }
//            .map { Int($0) }
//            .replaceError(with: nil)
//            .eraseToAnyPublisher()
//    }
//}

struct GetTempUseCase {
    
    private let fetch: (CityCoordinates) -> AnyPublisher<Int?, Never>
    
    private init(fetch: @escaping (CityCoordinates) -> AnyPublisher<Int?, Never>) {
        self.fetch = fetch
    }
    
    init() {
        self.fetch = { coords in
            let apiKey = Bundle.main.url(forResource: "apikeys", withExtension: "plist")
                .flatMap { try? Data(contentsOf: $0) }
                .flatMap { try? PropertyListSerialization.propertyList(from: $0, options: [], format: nil) }
                .flatMap { $0 as? Dictionary<String, String> }
                .flatMap { $0["openweather"] }
            guard let apiKey = apiKey else {
                return Just(nil)
                    .eraseToAnyPublisher()
            }
            
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.openweathermap.org"
            components.path = "/data/2.5/weather"
            components.queryItems = [
                URLQueryItem(name: "lat", value: "\(coords.lat)"),
                URLQueryItem(name: "lon", value: "\(coords.lon)"),
                URLQueryItem(name: "appid", value: "\(apiKey)")
            ]
            guard let url = components.url else {
                return Just(nil)
                    .eraseToAnyPublisher()
            }
            
            let request = URLRequest(url: url)
            return URLSession.shared.dataTaskPublisher(for: request)
                .map { data, response in
                    data
                }
                .decode(type: WeatherResponse.self, decoder: JSONDecoder())
                .map { $0.main.temp - 273.0 }
                .map { Int($0) }
                .replaceError(with: nil)
                .eraseToAnyPublisher()
        }
    }
    
    func callAsFunction(coords: CityCoordinates) -> AnyPublisher<Int?, Never> {
        fetch(coords)
    }
}

extension GetTempUseCase {
    
    static var trulyHot: GetTempUseCase {
        GetTempUseCase { _ in
            Future<Int?, Never> { promise in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    promise(.success(35))
                }
            }
            .eraseToAnyPublisher()
        }
    }
}
