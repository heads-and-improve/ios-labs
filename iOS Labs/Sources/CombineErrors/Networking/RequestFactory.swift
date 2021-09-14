//
//  NetworkingUseCase.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 08.09.2021.
//

import Foundation

struct RequestFactory<Value> {

    typealias MakePath = (_ apiKey: String?, _ value: Value) -> String?
    typealias TransformRequest = (_ request: URLRequest) -> URLRequest
    typealias TransformPath = (_ path: String) -> String

    private let endpointStr: String
    private let apiKey: String?
    private let make: MakePath
    private let transformRequest: TransformRequest
    private let transformPath: TransformPath

    init(endpointStr: String, apiKey: String? = nil, make: @escaping MakePath) {
        self.endpointStr = endpointStr
        self.apiKey = apiKey
        self.make = make
        self.transformRequest = { $0 }
        self.transformPath = { $0 }
    }
    
    private init(factory: RequestFactory, transform: @escaping TransformRequest) {
        self.endpointStr = factory.endpointStr
        self.apiKey = factory.apiKey
        self.make = factory.make
        self.transformRequest = transform
        self.transformPath = { $0 }
    }
    
    private init(factory: RequestFactory, transform: @escaping TransformPath) {
        self.endpointStr = factory.endpointStr
        self.apiKey = factory.apiKey
        self.make = factory.make
        self.transformRequest = { $0 }
        self.transformPath = transform
    }

    func callAsFunction(_ value: Value) -> URLRequest? {
        self.make(self.apiKey, value)
            .flatMap { path in
                var components = URLComponents()
                components.scheme = "https"
                components.host = self.endpointStr
                components.path = path
                return components.url
            }
            .flatMap { URLRequest(url: $0) }
            .flatMap(self.transformRequest)
    }

    func mapRequest(_ transform: @escaping TransformRequest) -> RequestFactory {
        RequestFactory(factory: self, transform: transform)
    }
    
    func mapPath(_ transform: @escaping TransformPath) -> RequestFactory {
        RequestFactory(factory: self, transform: transform)
    }
}

extension RequestFactory {

    func get() -> RequestFactory {
        mapRequest { request in
            var request = request
            request.httpMethod = "GET"
            return request
        }
    }

    func post() -> RequestFactory {
        mapRequest { request in
            var request = request
            request.httpMethod = "POST"
            return request
        }
    }
    
    func addingValue(_ value: String, forHTTPHeaderField header: String) -> RequestFactory {
        mapRequest { request in
            var request = request
            request.addValue(value, forHTTPHeaderField: header)
            return request
        }
    }

    func addingValue(_ token: String) -> RequestFactory {
        mapRequest { request in
            var request = request
            request.addValue(token, forHTTPHeaderField: "Authorization")
            return request
        }
    }
    
    func addingValue(_ token: @escaping () -> String) -> RequestFactory {
        addingValue(token())
    }

    func appending(_ data: Data?) -> RequestFactory {
        mapRequest { request in
            var request = request
            request.httpBody = data
            return request
        }
    }
}
