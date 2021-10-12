//
//  ThreeClosuresLazyFetchers.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 12.10.2021.
//

import Foundation
import Combine

struct ThreeClosuresLazyFetcher {
    
    static let getTemp: (CityCoords) -> (() -> AnyPublisher<Int?, Never>) = { coords in
        {
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
    
}
