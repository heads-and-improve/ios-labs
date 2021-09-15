//
//  GetPicturesIdsUseCase.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 14.09.2021.
//

import Foundation
import Combine

struct GetPhotosIdsUseCase: Networkable {

    private let factory: RequestFactory<String>

    init() {
        let apiKey = Bundle.main.url(forResource: "secrets", withExtension: "plist")
            .flatMap { try? Data(contentsOf: $0) }
            .flatMap { try? PropertyListSerialization.propertyList(from: $0, options: [], format: nil) }
            .flatMap { $0 as? Dictionary<String, String> }
            .flatMap { $0["apiKey"] }

        self.factory = .init(endpointStr: "https://www.flickr.com/services/rest/", apiKey: apiKey) { apiKey, value in
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

    func callAsFunction(_ tag: String) -> AnyPublisher<[FlickrResponse.Photos.Photo], Error> {
        factory(tag)
            .flatMap {
                self.load($0)
                    .map { (response: FlickrResponse) in response.photos.photo }
                    .eraseToAnyPublisher()
            }
            ?? Fail(error: NetworkableError.other("Could not make URLRequest"))
            .eraseToAnyPublisher()
    }
    
}
