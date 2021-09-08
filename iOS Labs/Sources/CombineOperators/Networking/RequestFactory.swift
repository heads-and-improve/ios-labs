//
//  NetworkingUseCase.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 08.09.2021.
//

import Foundation
import Combine

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
    
    func map(_ transform: @escaping (URLRequest) -> URLRequest) -> RequestFactory {
        RequestFactory(
            endpointStr: self.endpointStr,
            apiKey: self.apiKey,
            make: { endpoint, apiKey, value in
                guard var request = self.make(endpoint, apiKey, value) else { return nil }
                request = transform(request)
                return request
            }
        )
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

    func authorize(withToken token: String) -> RequestFactory {
        map { request in
            var request = request
            request.addValue(token, forHTTPHeaderField: "Authorization")
            return request
        }
    }

    func append(_ data: Data) -> RequestFactory {
        map { request in
            var request = request
            request.httpBody = data
            return request
        }
    }
}
