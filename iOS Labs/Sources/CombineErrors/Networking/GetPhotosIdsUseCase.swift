//
//  GetPicturesIdsUseCase.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 14.09.2021.
//

import Foundation
import Combine

struct GetPhotosIdsUseCase: Networkable {
    
    typealias Photo = FlickrResponse.Photos.Photo

    private let factory: RequestFactory<String>

    init() {
        let apiKey = Bundle.main.url(forResource: "secrets", withExtension: "plist")
            .flatMap { try? Data(contentsOf: $0) }
            .flatMap { try? PropertyListSerialization.propertyList(from: $0, options: [], format: nil) }
            .flatMap { $0 as? Dictionary<String, String> }
            .flatMap { $0["apiKey"] }

        self.factory = .init("https://www.flickr.com/services/rest/", apiKey: apiKey) { apiKey, value in
            guard let apiKey = apiKey else { return nil }
            return "?method=flickr.photos.search"
                + "&api_key=\(apiKey)"
                + "&tags=\(value)"
                + "&per_page=25"
                + "&page=1"
                + "&format=json"
                + "&nojsoncallback=1"
        }
    }

    func callAsFunction(_ tag: String) -> AnyPublisher<[Photo], Error> {
        if let request = factory(tag) {
            return self.load(request)
                .map { (response: FlickrResponse) in response.photos.photo }
                .eraseToAnyPublisher()
        } else {
            return Fail<[Photo], URLError>(error: URLError(.badURL, userInfo: [:]))
//                .mapError { $0 as Error }
                .mapError { NetworkableError.url($0) }
                .eraseToAnyPublisher()
        }
    }
    
}
