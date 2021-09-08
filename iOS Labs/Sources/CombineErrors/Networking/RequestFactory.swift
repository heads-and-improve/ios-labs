//
//  NetworkingUseCase.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 08.09.2021.
//

import Foundation
import Combine

struct RequestFactory {

    typealias Make = (_ apiKey: String?, _ value: String) -> String
    typealias Transform = (_ request: URLRequest) -> URLRequest

    private let endpointStr: String
    private let apiKey: String?
    private let make: Make
    private let transform: Transform

    init(endpointStr: String, apiKey: String? = nil, make: @escaping Make) {
        self.endpointStr = endpointStr
        self.apiKey = apiKey
        self.make = make
        self.transform = { $0 }
    }
    
    private init(factory: RequestFactory, transform: @escaping Transform) {
        self.endpointStr = factory.endpointStr
        self.apiKey = factory.apiKey
        self.make = factory.make
        self.transform = transform
    }

    func callAsFunction(_ value: String) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = self.endpointStr
        components.path = self.make(self.apiKey, value)
        return components.url
            .flatMap { URLRequest(url: $0) }
            .flatMap(self.transform)
    }

    func map(_ transform: @escaping Transform) -> RequestFactory {
        RequestFactory(factory: self, transform: transform)
    }
}

extension RequestFactory {

    func get() -> RequestFactory {
        map { request in
            var request = request
            request.httpMethod = "GET"
            return request
        }
    }

    func post() -> RequestFactory {
        map { request in
            var request = request
            request.httpMethod = "POST"
            return request
        }
    }
    
    func addingValue(_ value: String, forHTTPHeaderField header: String) -> RequestFactory {
        map { request in
            var request = request
            request.addValue(value, forHTTPHeaderField: header)
            return request
        }
    }

    func addingValue(_ token: String) -> RequestFactory {
        map { request in
            var request = request
            request.addValue(token, forHTTPHeaderField: "Authorization")
            return request
        }
    }
    
    func addingValue(_ token: @escaping () -> String) -> RequestFactory {
        addingValue(token())
    }

    func appending(_ data: Data?) -> RequestFactory {
        map { request in
            var request = request
            request.httpBody = data
            return request
        }
    }
}
