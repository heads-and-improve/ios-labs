//
//  GetPicturesIdsUseCase.swift
//  iOS Labs
//
//  Created by Андрей Исаев on 14.09.2021.
//

import Foundation
import Combine

struct GetPhotosIdsUseCase {
    
    typealias Photo = FlickrResponse.Photos.Photo

    private let api = RequestProvider<FlickrApi>()

    init() { }

    func callAsFunction(_ tag: String) -> AnyPublisher<[Photo], Error> {
        api.task(.getPhotosByTag(tag))
            .map { (response: FlickrResponse) in
                response.photos.photo
            }
            .eraseToAnyPublisher()
    }
    
}
